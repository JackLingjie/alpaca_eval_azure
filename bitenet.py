import transformers
import torch
device = "cuda"

# Load the tokenizer and model
tokenizer = transformers.AutoTokenizer.from_pretrained("/mnt/lingjiejiang/textual_aesthetics/exp/saves/bitnet_glan2_2048_default_template/fullft_lr2e5_4kstep/sft/checkpoint-3000", trust_remote_code=True)
model = transformers.AutoModelForCausalLM.from_pretrained("/mnt/lingjiejiang/textual_aesthetics/exp/saves/bitnet_glan2_2048_default_template/fullft_lr2e5_4kstep/sft/checkpoint-3000", trust_remote_code=True, torch_dtype=torch.bfloat16, attn_implementation = "flash_attention_2")
model.to(device)

def generate_response(prompt):
    inputs = tokenizer(prompt, return_tensors="pt").to(model.device)
    tokens = model.generate(
        **inputs,
        max_new_tokens=30,
        temperature=1.0,
        top_p=0.95,
        do_sample=True,
    )
    return tokenizer.decode(tokens[0], skip_special_tokens=True).replace(prompt, '')

# Interactive loop
if __name__ == "__main__":
    print("Interactive prompt. Type 'exit' to quit.")
    while True:
        user_input = input("You: ")
        if user_input.lower() == 'exit':
            break
        response = generate_response(user_input)
        print("Model:", response)

