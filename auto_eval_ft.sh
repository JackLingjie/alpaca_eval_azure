#!/bin/bash  
set -x

export CUDA_VISIBLE_DEVICES=3

# 参数列表  
PARAMS=(  
    "ta_rejected_llama3.1_instruct_2048_default_template_v2"
    # "ta_rejected_tuluv2_dpo_2048_default_template_bsz1_acc8"
    # "ta_rejected_tuluv2_dpo_2048_default_template_bsz1_acc8_v2"
    # "ta_rejected_tuluv2_dpo_2048_default_template_bsz1_acc8_v3"
    # "ta_chosen_tuluv2_dpo_2048_default_template"
    # "ta_chosen_llama3.1_instruct_dpo_2048"
    # "ta_rejected_llama3.1_instruct_dpo_2048" 
    # "wildchat_v2_8b_2048_default_template_full_sft"
    # "wildchat_v2_8b_2048_default_template_fullft_e5_9485" 
    # "wildchat_v2_8b_2048_default_template_fullft_lr5e6_3794" 
    # "wildchat_v2_8b_2048_default_template_fullft_lr5e6_e5_9485" 
    # "tulu-2-7b"  
    # "tulu_lora_sft_base_template_8b" 
    # "tulu_v2_8b_base_template_dpo" 
    # "tulu_v2_8b_bsz64_default_template_dpo" 
    # "tulu_lora_sft_default_template_8b" 
    # "Meta-Llama-3.1-8B-Instruct"
    # "Meta-Llama-3.1-8B"
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
  echo "执行参数: $PARAM" | tee -a $LOG_FILE  
  bash eval_script/tulu_default_template_dpo.sh $PARAM | tee -a $LOG_FILE  
  echo "----------------------------------------" | tee -a $LOG_FILE  
done  

echo "所有任务已完成。" | tee -a $LOG_FILE  
