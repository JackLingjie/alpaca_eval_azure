# need a GPU for local models
alpaca_eval evaluate_from_model \
  --model_configs 'tulu-sft-Llama3_1-8B' \
  --annotators_config 'alpaca_eval_gpt4_turbo_fn'  
# eval
alpaca_eval --model_outputs './data/Meta-Llama-3.1-8B.json' \
--annotators_config 'alpaca_eval_gpt4_turbo_fn'    

# eval
alpaca_eval --model_outputs './data/Meta-Llama-3.1-8B-Instruct.json' \
--annotators_config 'alpaca_eval_gpt4_turbo_fn'    



## generate output
### llama3-instruct 
python generate_response.py --model-name "Meta-Llama-3.1-8B-Instruct"

python generate_response.py --model-path "/mnt/lingjiejiang/textual_aesthetics/model_checkpoint/sft_merge_checkpoints" --model-name "tulu-lora-sft-llama3-8b-base"

alpaca_eval --model_outputs './data/tulu-lora-sft-llama3-8b-base.json' \
--annotators_config 'alpaca_eval_gpt4_turbo_fn'


CUDA_VISIBLE_DEVICES=1 python generate_response.py --model-path "/mnt/lingjiejiang/textual_aesthetics/model_checkpoint/sft_merge_checkpoints" --model-name "tulu-dpo-llama3-8b-base"

alpaca_eval --model_outputs './data/tulu-dpo-llama3-8b-base.json' \
--annotators_config 'alpaca_eval_gpt4_turbo_fn'   


alpaca_eval --model_outputs './data/tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v2.json' \
--annotators_config 'alpaca_eval_gpt4_turbo_fn'   

alpaca_eval --model_outputs './data/tulu_lora_sft_default_template_8b.json' \
--annotators_config 'alpaca_eval_gpt4_turbo_fn'   

bash eval_script/tulu_default_template_dpo.sh tulu_v2_8b_bsz64_default_template_dpo