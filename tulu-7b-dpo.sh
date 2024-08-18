#!/bin/bash
set -x

DEFAULT_MODEL_NAME="tulu-2-dpo-7b"
MODEL_NAME=${1:-$DEFAULT_MODEL_NAME}

python generate_response.py \
    --model-path "allenai"\
    --model-name "$MODEL_NAME"

alpaca_eval --model_outputs "./data/$MODEL_NAME.json" \
--annotators_config "alpaca_eval_gpt4_turbo_fn" 