# need a GPU for local models
alpaca_eval evaluate_from_model \
  --model_configs 'tulu-sft-Llama3_1-8B' \
  --annotators_config 'alpaca_eval_gpt4_turbo_fn'      