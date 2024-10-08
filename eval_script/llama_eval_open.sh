#!/bin/bash  
set -x  
  
# 默认参数  
DEFAULT_MODEL_NAME="MagpieLM-8B-Chat-v0.1"  
DEFAULT_HYPERPARAMETER="Magpie-Align"  

# 检查是否传入了参数，如果没有则使用默认值  
HYPERPARAMETER=${1:-$DEFAULT_HYPERPARAMETER}  
MODEL_NAME=${2:-$DEFAULT_MODEL_NAME}  

  
# 拼接新的 model-path  
# MODEL_PATH="/mnt/lingjiejiang/textual_aesthetics/exp/saves/${MODEL_NAME}/${HYPERPARAMETER}/sft/${CHECKPOINT}"  
MODEL_PATH="${HYPERPARAMETER}/${MODEL_NAME}"  

SAVE_MODEL_ID="${MODEL_NAME}"
echo $SAVE_MODEL_ID

python generate_response_fullft.py \
    --model-path "$MODEL_PATH" \
    --model-name "$SAVE_MODEL_ID" 
  
alpaca_eval --model_outputs "./data/$SAVE_MODEL_ID.json" \
    --annotators_config "alpaca_eval_gpt4_turbo_fn"  
  
# 备份 annotation 文件  
cp data/alpaca_eval_gpt4_turbo_fn/annotations.json "data/annotations_bak/${SAVE_MODEL_ID}_annotations.json"  
cp data/alpaca_eval_gpt4_turbo_fn/leaderboard.csv "data/leaderboard_bak/${MODEL_NAME}_leaderboard.csv"  
