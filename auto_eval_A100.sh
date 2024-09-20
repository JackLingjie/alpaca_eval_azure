#!/bin/bash  
set -x


# 参数列表  
PARAMS=( 
    "tulu_2048_default_template_trible_uf_dpo"
    "tulu_2048_default_template_trible_rejected_ta_dpo"
    "tulu_2048_default_template_trible_chosen_ta_dpo_1500"
    "tulu_2048_default_template_trible_chosen_ta_dpo"
    "tulu_2048_default_template_trible_rejected_ta_dpo_1500"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v9"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v9-1500"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v11"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v11_1500"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v12"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v12_1500"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v13"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v13-1500"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v14"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v14-1500"
    # "ta_llama3_instruct_dpo_list_bsz1_trible_debug_v2-1500"
    # "ta_llama3_instruct_dpo_list_bsz1_trible_debug_v4"
    # "ta_llama3_instruct_dpo_list_bsz1_trible_debug_v4_1500"
    # "ta_llama3_instruct_dpo_list_bsz1_trible_debug_v5"
    # "ta_llama3_instruct_dpo_list_bsz1_trible_debug_v5_1500"
    # "tulu_uf_ta_v2_2048_default_template_dpo_1000"
    # "tulu_uf_ta_v2_2048_default_template_dpo_1500"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v9"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v10"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v10_1500"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v4-1500"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v5_1500"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v6_1500"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v7_1500"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v8_1500"
    # "tulu_v2_8b_2048_default_template_dpo"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v4"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v5"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v6"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v7"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v8"
    # "ta_llama3_instruct_dpo_list_bsz1_trible_debug_v1"
    # "ta_llama3_instruct_dpo_list_bsz1_trible_debug_v1-1500"
    # "ta_rejected_tuluv2_dpo_2048_default_template_bsz1_acc8_v2_500"
    # "ta_rejected_tuluv2_dpo_2048_default_template_bsz1_acc8_v2_1000"
    # "ta_rejected_llama3.1_instruct_2048_default_template_v2-500"
    # "ta_rejected_llama3.1_instruct_2048_default_template_v2-1000"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v2"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_v3"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_1000"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_1500"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug_500"
    # "tulu_v2_8b_default_template_dpo_list_bsz1_trible_debug"
    # "glanchat_v2_8b_2048_default_template_11400"
      # "glanchat_v2_glan_v2_8b_2048_default_template_fullft_lr5e6_e3_fx_glan_9500"
    # "ta_v2_rejected_noneed_length_tuluv2_dpo_2048_default_template_bsz1_acc8_v2"
    # "ta_v2_rejected_noneed_tuluv2_dpo_2048_default_template_bsz1_acc8_v2"
    # "ta_v2_chosen_tuluv2_dpo_2048_default_template_bsz1_acc8_v2"
    # "ta_v2_chosen_tuluv2_dpo_2048_default_template_bsz1_acc8_v5"
    # "ta_v2_rejected_tuluv2_dpo_2048_default_template_bsz1_acc8_v5"
    # "ta_rejected_tuluv2_dpo_2048_default_template_bsz1_acc8_v4" 
    # "ta_v2_rejected_tuluv2_dpo_2048_default_template_bsz1_acc8" 
    # "ta_v2_rejected_tuluv2_dpo_2048_default_template_bsz1_acc8_v2"
    # "ta_v2_rejected_tuluv2_dpo_2048_default_template_bsz1_acc8_v3"
    # "ta_v2_rejected_tuluv2_dpo_2048_default_template_bsz1_acc8_v4"
    # "glan_v2_8b_2048_default_template_9490"
    # "glanchat_v2_8b_2048_default_template_fullft_lr5e6_e3"
    # "ta_rejected_llama3.1_instruct_2048_default_template_v2"
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
