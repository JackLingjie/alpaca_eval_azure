#!/bin/bash  
set -x  
export CUDA_VISIBLE_DEVICES=0  
  
# 参数列表，每个元素包含model_name, hyperparameter, 和 checkpoint，用逗号分隔  
PARAMS=(  
  # "glanchat_v2.1_8b_2048_default_template,fullft_lr5e6_e3,checkpoint-9918"
  "magpie_8b_2048_default_template,fullft_lr5e6_e3,checkpoint-8500"
  # "glanchat_v2.1_8b_2048_default_template,fullft_lr5e6_e3,checkpoint-8500"  
  # "glan_v2_glanchat_v2_8b_2048_default_template,fullft_lr5e6_e3_fx,checkpoint-33000" 
  # "ta_rejected_tuluv2_dpo_2048_default_template_bsz1_acc8,fullft_lr5e6_e3,checkpoint-8500"  
  # "ta_rejected_tuluv2_dpo_2048_default_template_bsz1_acc8_v2,fullft_lr5e6_e3,checkpoint-8500"  
  # "ta_rejected_tuluv2_dpo_2048_default_template_bsz1_acc8_v3,fullft_lr5e6_e3,checkpoint-8500"  
  # "ta_chosen_tuluv2_dpo_2048_default_template,fullft_lr5e6_e3,checkpoint-8500"  
  # "ta_chosen_llama3.1_instruct_dpo_2048,fullft_lr5e6_e3,checkpoint-8500"  
  # "ta_rejected_llama3.1_instruct_dpo_2048,fullft_lr5e6_e3,checkpoint-8500"  
  # "wildchat_v2_8b_2048_default_template_full_sft,fullft_lr5e6_e3,checkpoint-8500"  
  # "wildchat_v2_8b_2048_default_template_fullft_e5_9485,fullft_lr5e6_e3,checkpoint-8500"  
  # "wildchat_v2_8b_2048_default_template_fullft_lr5e6_3794,fullft_lr5e6_e3,checkpoint-8500"  
  # "wildchat_v2_8b_2048_default_template_fullft_lr5e6_e5_9485,fullft_lr5e6_e3,checkpoint-8500"  
  # "tulu-2-7b,fullft_lr5e6_e3,checkpoint-8500"  
  # "tulu_lora_sft_base_template_8b,fullft_lr5e6_e3,checkpoint-8500"  
  # "tulu_v2_8b_base_template_dpo,fullft_lr5e6_e3,checkpoint-8500"  
  # "tulu_v2_8b_bsz64_default_template_dpo,fullft_lr5e6_e3,checkpoint-8500"  
  # "tulu_lora_sft_default_template_8b,fullft_lr5e6_e3,checkpoint-8500"  
  # "Meta-Llama-3.1-8B-Instruct,fullft_lr5e6_e3,checkpoint-8500"  
  # "Meta-Llama-3.1-8B,fullft_lr5e6_e3,checkpoint-8500"  
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
  IFS=',' read -r model_name hyperparameter checkpoint <<< "$PARAM"  
  
  echo "执行参数: $model_name, $hyperparameter, $checkpoint" | tee -a $LOG_FILE  
  
  # 调用上面的bash脚本并传递参数  
  bash eval_script/llama_ft_eval.sh "$model_name" "$hyperparameter" "$checkpoint" | tee -a $LOG_FILE  
  
  echo "----------------------------------------" | tee -a $LOG_FILE  
done  
  
echo "所有任务已完成。" | tee -a $LOG_FILE  
