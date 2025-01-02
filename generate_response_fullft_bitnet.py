import transformers  
import torch  
from tqdm import tqdm  
import datasets  
import json  
import argparse  
  
# Argument parsing  
parser = argparse.ArgumentParser(description='Set model name.')  
parser.add_argument('--model-name', type=str, required=True, help='Name of the model to use')  
parser.add_argument('--model-path', type=str, default="/home/lidong1/jianglingjie/LLama-Factory/model_checkpoint/huggingface", help='Dir of the model to use')  
args = parser.parse_args()  
  
path_dir = args.model_path  
model_name = args.model_name  
  
# Load the tokenizer and model  
tokenizer = transformers.AutoTokenizer.from_pretrained(path_dir, trust_remote_code=True)  
model = transformers.AutoModelForCausalLM.from_pretrained(path_dir, trust_remote_code=True, torch_dtype=torch.bfloat16)  
model.to("cuda")  
  
print(f"model name: {model_name}")  
print(f"model_path: {path_dir}/{model_name}")  
  
gen_kwargs_hf = {  
    "max_new_tokens": 2048,  
    "temperature": 0.0,  
    "do_sample": False,  
}  
  
gen_kwargs_hf['eos_token_id'] = [tokenizer.eos_token_id, tokenizer.convert_tokens_to_ids("<|end_of_text|>")]
gen_kwargs_hf['pad_token_id'] = tokenizer.eos_token_id 

def generate_response(prompt):  
    inputs = tokenizer(prompt, return_tensors="pt", add_special_tokens=False).to(model.device)  
    tokens = model.generate(**inputs, **gen_kwargs_hf)  
    prompt = prompt.replace("<|begin_of_text|>", "")
    return tokenizer.decode(tokens[0], skip_special_tokens=True).replace(prompt, '')  
  
# Load dataset  
eval_set = datasets.load_dataset("tatsu-lab/alpaca_eval", "alpaca_eval")["eval"]  
  
# Convert dataset examples to messages  
def convert_to_message(example):  
    messages = [{"role": "user", "content": example["instruction"]}]  
    example["messages"] = tokenizer.apply_chat_template(messages, tokenize=False, add_generation_prompt=True)  
    return example  
  
eval_set = eval_set.map(convert_to_message)  
  
# Generate responses  
outputs_text = []  
for example in tqdm(eval_set):  
    response = generate_response(example['messages'])  
    outputs_text.append(response)  
  
# Update dataset with model outputs  
eval_set = eval_set.remove_columns(["output"])  # Remove the existing 'output' column if it exists  
eval_set = eval_set.remove_columns(["messages"])  
eval_set = eval_set.add_column("output", outputs_text)  
  
def rename_generator(sample):  
    sample['generator'] = f"{model_name}"  
    return sample  
  
eval_set = eval_set.map(rename_generator)  
eval_set.to_json(f"{model_name}.jsonl", batch_size=128, num_proc=8)  
  
# Save data  
export_dataset = eval_set  
export_data_list = [dict(row) for row in export_dataset]  
print(f"export data length {len(export_data_list)}")  
with open(f'./data/{model_name}.json', 'w', encoding='utf-8') as f:  
    json.dump(export_data_list, f, ensure_ascii=False, indent=4)  