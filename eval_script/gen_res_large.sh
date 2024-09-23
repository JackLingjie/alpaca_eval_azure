#!/bin/bash
set -x

DEFAULT_MODEL_NAME="tulu_lora_sft_default_template_8b"
MODEL_NAME=${1:-$DEFAULT_MODEL_NAME}

CUDA_VISIBLE_DEVICES=0,1,2,3 python generate_response_large.py \
    --model-path "/mnt/lingjiejiang/textual_aesthetics/model_checkpoint/sft_merge_checkpoints"\
    --model-name "$MODEL_NAME"

# alpaca_eval --model_outputs "./data/$MODEL_NAME.json" \
# --annotators_config "alpaca_eval_gpt4_turbo_fn" 

# # bak annotation file
# cp data/alpaca_eval_gpt4_turbo_fn/annotations.json "data/annotations_bak/${MODEL_NAME}_annotations.json"  
# cp data/alpaca_eval_gpt4_turbo_fn/leaderboard.csv "data/leaderboard_bak/${MODEL_NAME}_leaderboard.csv"  