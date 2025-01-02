#!/bin/bash  
set -x  
  
# 默认参数  
DEFAULT_MODEL_NAME="tulu_lora_sft_default_template_8b"  
DEFAULT_HYPERPARAMETER="fullft_lr5e6_e3"  
DEFAULT_STAGE="sft"  
DEFAULT_CHECKPOINT="checkpoint-8500"   
  
# 检查是否传入了参数，如果没有则使用默认值  
MODEL_NAME=${1:-$DEFAULT_MODEL_NAME}  
HYPERPARAMETER=${2:-$DEFAULT_HYPERPARAMETER}  
STAGE=${3:-$DEFAULT_STAGE}  
CHECKPOINT=${4:-$DEFAULT_CHECKPOINT}    
  
# 拼接新的 model-path  
MODEL_PATH="/mnt/lingjiejiang/textual_aesthetics/exp/saves/${MODEL_NAME}/${HYPERPARAMETER}/${STAGE}/${CHECKPOINT}"  

SAVE_MODEL_ID="${MODEL_NAME}_${STAGE}_${CHECKPOINT}"
echo $SAVE_MODEL_ID

# python generate_response_fullft_bitnet.py \
#     --model-path "$MODEL_PATH" \
#     --model-name "$SAVE_MODEL_ID" 
  
alpaca_eval --model_outputs "./data/$SAVE_MODEL_ID.json" \
    --annotators_config "alpaca_eval_gpt4_turbo_fn"  
  
# 备份 annotation 文件  
cp data/alpaca_eval_gpt4_turbo_fn/annotations.json "data/annotations_bak/${SAVE_MODEL_ID}_annotations.json"  
cp data/alpaca_eval_gpt4_turbo_fn/leaderboard.csv "data/leaderboard_bak/${SAVE_MODEL_ID}_leaderboard.csv"  
