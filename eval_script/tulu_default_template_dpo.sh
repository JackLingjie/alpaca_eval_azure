#!/bin/bash
set -x

DEFAULT_MODEL_NAME="tulu_lora_sft_default_template_8b"
MODEL_NAME=${1:-$DEFAULT_MODEL_NAME}

python generate_response.py \
    --model-path "/mnt/lingjiejiang/textual_aesthetics/model_checkpoint/sft_merge_checkpoints"\
    --model-name "$MODEL_NAME"

alpaca_eval --model_outputs "./data/$MODEL_NAME.json" \
--annotators_config "alpaca_eval_gpt4_turbo_fn" 