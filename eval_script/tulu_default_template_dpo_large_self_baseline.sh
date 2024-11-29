#!/bin/bash
set -x

DEFAULT_MODEL_NAME="tulu_lora_sft_default_template_8b"
MODEL_NAME=${1:-$DEFAULT_MODEL_NAME}

# 检查文件是否存在  
if [ -f "data/${MODEL_NAME}.json" ]; then  
  echo "文件 data/${MODEL_NAME}.json 存在，跳过  gen_answer.py 执行。"  
else  

python generate_response.py \
    --model-path "/mnt/lingjiejiang/textual_aesthetics/model_checkpoint/sft_merge_checkpoints"\
    --model-name "$MODEL_NAME" 
  
fi 

src/alpaca_eval/evaluators_configs/
alpaca_eval --model_outputs "./data/$MODEL_NAME.json" \
--annotators_config "alpaca_eval_gpt4_turbo_fn" \
--reference_outputs "gemma_glan1.5_6000ckpt"

# bak annotation file
cp data/alpaca_eval_gpt4_turbo_fn/annotations.json "data/annotations_bak/${MODEL_NAME}_annotations.json"  
cp data/alpaca_eval_gpt4_turbo_fn/leaderboard.csv "data/leaderboard_bak/${MODEL_NAME}_leaderboard.csv"  