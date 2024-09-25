#!/bin/bash  
set -x  
export CUDA_VISIBLE_DEVICES=0  
  
# 参数列表，每个元素包含model_name, hyperparameter, 和 checkpoint，用逗号分隔  
PARAMS=(  
    # "magpie_8b_2048_default_template_dpo,fullft,dpo,checkpoint-2756"
    "Magpie-Align,MagpieLM-8B-Chat-v0.1"
    "Magpie-Align,MagpieLM-4B-Chat-v0.1"
  
  # 添加更多参数  
)  
  
# 原始日志文件名  
LOG_FILE="evaluation_log"  
counter=0  
  
# 遍历模型列表，生成新的文件名  
for model in "${PARAMS[@]}"; do  
  if [ $counter -ge 3 ]; then  
    break  
  fi  
  # 拼接模型名到log_file后  
  LOG_FILE="${LOG_FILE}_${model}"  
  counter=$((counter + 1))  
done  
  
# 最终的文件名  
LOG_FILE="./eval_logs/${LOG_FILE}.txt"  
  
# 清空日志文件  
> "$LOG_FILE"  
echo $LOG_FILE  
  
# 遍历参数列表  
for PARAM in "${PARAMS[@]}"; do  
  # 将参数分割为模型名称、超参数和checkpoint  
  IFS=',' read -r hyperparameter model_name <<< "$PARAM" 
  
  echo "执行参数: $model_name, $hyperparameter" | tee -a $LOG_FILE  
  
  # 调用上面的bash脚本并传递参数  
  bash eval_script/llama_eval_open.sh "$hyperparameter" "$model_name"   | tee -a $LOG_FILE  
  
  echo "----------------------------------------" | tee -a $LOG_FILE  
done  
  
echo "所有任务已完成。" | tee -a $LOG_FILE  
