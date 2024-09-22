from vllm import LLM, SamplingParams
from tqdm import tqdm
import datasets
import json
import argparse 

parser = argparse.ArgumentParser(description='Set model name.')  
parser.add_argument('--model-name', type=str, required=True, help='Name of the model to use')  
parser.add_argument('--model-path', type=str, default="/home/lidong1/jianglingjie/LLama-Factory/model_checkpoint/huggingface", help='Dir of the model to use') 
args = parser.parse_args()  
path_dir = args.model_path
model_name = args.model_name 

# template = "{{ '<|begin_of_text|>' }}{% if messages[0]['role'] == 'system' %}{% set system_message = messages[0]['content'] %}{% endif %}{% if system_message is defined %}{{ '<|start_header_id|>system<|end_header_id|>\n\n' + system_message + '<|eot_id|>' }}{% endif %}{% for message in messages %}{% set content = message['content'] %}{% if message['role'] == 'user' %}{{ '<|start_header_id|>user<|end_header_id|>\n\n' + content + '<|eot_id|><|start_header_id|>assistant<|end_header_id|>\n\n' }}{% elif message['role'] == 'assistant' %}{{ content + '<|eot_id|>' }}{% endif %}{% endfor %}"
template = "{% if messages[0]['role'] == 'system' %}{% set system_message = messages[0]['content'] %}{% endif %}{% if system_message is defined %}{{ system_message + '\n' }}{% endif %}{% for message in messages %}{% set content = message['content'] %}{% if message['role'] == 'user' %}{{ 'Human: ' + content + '\nAssistant:' }}{% elif message['role'] == 'assistant' %}{{ content + '<|end_of_text|>' + '\n' }}{% endif %}{% endfor %}"

# model_name = "Meta-Llama-3.1-8B-Instruct"
# model_name = "Meta-Llama-3.1-8B"
# Create an LLM.
llm = LLM(model=f"{path_dir}/{model_name}")

print(f"model name: {model_name}")
print(f"model_path: {path_dir}/{model_name}")

gen_kwargs_vllm = {
    "max_tokens": 2048,
    "temperature": 0.0,
}
tokenizer = llm.get_tokenizer()
if tokenizer.chat_template is None:
    tokenizer.chat_template = template
    tokenizer.chat_template = tokenizer.chat_template.replace("<|eot_id|>", tokenizer.eos_token)
    # tokenizer.chat_template
    gen_kwargs_vllm['stop_token_ids'] = [tokenizer.eos_token_id, tokenizer.convert_tokens_to_ids("<|eot_id|>")]
    print(f"tokenizer.chat_template: {tokenizer.chat_template}")
    print("tokenizer is None, use setted template")
else:
    gen_kwargs_vllm['stop_token_ids'] = [tokenizer.eos_token_id, tokenizer.convert_tokens_to_ids("<|end_of_text|>")]
    print("use original template")
# messages = tokenizer.apply_chat_template(messages, tokenize=False)


sampling_params = SamplingParams(**gen_kwargs_vllm)

eval_set = datasets.load_dataset("tatsu-lab/alpaca_eval", "alpaca_eval")["eval"]

def convert_to_message(example):  
    messages = [{"role": "user", "content": example["instruction"]}]  
    example["messages"] = tokenizer.apply_chat_template(messages, tokenize=False, add_generation_prompt=True)  
    return example  
eval_set = eval_set.map(convert_to_message)

encoded_inputs = tokenizer.batch_encode_plus(  
    eval_set['messages'],  
    add_special_tokens=False,
) 
input_ids = encoded_inputs['input_ids']  
# eval_set['messages']
outputs = llm.generate(prompt_token_ids=input_ids, sampling_params=sampling_params)
outputs_text = [x.outputs[0].text for x in outputs]
eval_set = eval_set.remove_columns(["output"])  # Remove the existing 'output' column if it exists  
eval_set = eval_set.remove_columns(["messages"])
eval_set = eval_set.add_column("output", outputs_text)  
def rename_generator(sample):
    sample['generator'] = f"{model_name}"
    return sample
eval_set = eval_set.map(rename_generator)
eval_set.to_json(f"{model_name}.jsonl", batch_size=128, num_proc=8)

## save data

export_dataset = eval_set
export_data_list = [dict(row) for row in export_dataset]
print(f"export data length {len(export_data_list)}")
with open(f'./data/{model_name}.json', 'w', encoding='utf-8') as f:  
    json.dump(export_data_list, f, ensure_ascii=False, indent=4)  