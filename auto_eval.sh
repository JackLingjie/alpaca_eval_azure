#!/bin/bash  
set -x

export CUDA_VISIBLE_DEVICES=3
# 参数列表  
PARAMS=(  
    # "tulu_v2_8b_2048_default_template_sft" 
    # "tulu_v2_8b_2048_default_template_dpo" 
  "tulu-2-7b"  
  # "allenai/tulu-2-dpo-7b"
  # "Meta-Llama-3.1-8B-Instruct"
  # 添加更多参数  
)  

# 原始日志文件名  
LOG_FILE="evaluation_log"  
  
# 遍历模型列表，生成新的文件名  
for model in "${PARAMS[@]}"; do  
    # 拼接模型名到log_file后  
    LOG_FILE="${LOG_FILE}_${model}"  
done  
  
# 最终的文件名  
LOG_FILE="./eval_logs/${LOG_FILE}.txt" 

# 清空日志文件  
> "$LOG_FILE" 

# 遍历参数列表  
for PARAM in "${PARAMS[@]}"; do  
  echo "执行参数: $PARAM" | tee -a $LOG_FILE  
  bash eval_script/tulu_default_template_dpo.sh $PARAM | tee -a $LOG_FILE  
  echo "----------------------------------------" | tee -a $LOG_FILE  
done  

echo "所有任务已完成。" | tee -a $LOG_FILE  
