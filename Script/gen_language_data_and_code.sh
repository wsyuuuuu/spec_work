#!/bin/bash

source $(dirname "$0")/defines.properties

DEFINE_FILE_DEFAULT=${REPO_ROOT_PATH}/.defines/__language_default__.xml
DEFINE_FILE_GLOBAL=${REPO_ROOT_PATH}/.defines/__language_global__.xml
INPUT_DATA_DIR=${REPO_ROOT_PATH}/Language
INPUT_TEXT_FILE=${REPO_ROOT_PATH}/Language/language.xlsx
TEMPLATE_SEARCH_PATH=${REPO_ROOT_PATH}/Script/CustomTemplates


for LANGUAGE in ${LANGUAGE_CODES[*]}; do

  # 生成Default本地化数据
  dotnet ${LUBAN_CLIENT_SERVER_DLL} -j cfg --\
   -d ${DEFINE_FILE_DEFAULT} \
   -s client \
   --input_data_dir ${INPUT_DATA_DIR} \
   --output_data_dir ${CLIENT_SPEC_DATA_OUTPUT}/DefaultText/${LANGUAGE} \
   --gen_types data_bin \
   --l10n:input_text_files ${INPUT_TEXT_FILE} \
   --l10n:text_field_name ${LANGUAGE} \
   --l10n:output_not_translated_text_file ${NOT_LOCALIZED_PATH}/Default_${LANGUAGE}.txt \
  # mv ${SCRIPT_PATH}/../Temp/defaulttext.bytes ${OUTPUT_DATA_PATH}/default_${LANGUAGE}_text.bytes

  # 生成Global本地化数据
  dotnet ${LUBAN_CLIENT_SERVER_DLL} -j cfg --\
   -d ${DEFINE_FILE_GLOBAL} \
   -s client \
   --input_data_dir ${INPUT_DATA_DIR} \
   --output_data_dir ${CLIENT_SPEC_DATA_OUTPUT}/GlobalText/${LANGUAGE} \
   --gen_types data_bin \
   --l10n:input_text_files ${INPUT_TEXT_FILE} \
   --l10n:text_field_name ${LANGUAGE} \
   --l10n:output_not_translated_text_file ${NOT_LOCALIZED_PATH}/Global_${LANGUAGE}.txt \
  # mv ${SCRIPT_PATH}/../Temp/globaltext.bytes ${OUTPUT_DATA_PATH}/../Editor\ Default\ Resources/global_${LANGUAGE}_text.bytes
done


# 生成Default本地化代码
dotnet ${LUBAN_CLIENT_SERVER_DLL} -t ${TEMPLATE_SEARCH_PATH} -j cfg --\
 -d ${DEFINE_FILE_DEFAULT} \
 -s client \
 --input_data_dir ${INPUT_DATA_DIR} \
 --output_code_dir ${CLIENT_SPEC_CODE_OUTPUT}/DefaultText \
 --gen_types code_cs_unity_bin \


# 生成Global本地化代码
dotnet ${LUBAN_CLIENT_SERVER_DLL} -t ${TEMPLATE_SEARCH_PATH} -j cfg --\
 -d ${DEFINE_FILE_GLOBAL} \
 -s client \
 --input_data_dir ${INPUT_DATA_DIR} \
 --output_code_dir ${CLIENT_SPEC_CODE_OUTPUT}/GlobalText \
 --gen_types code_cs_unity_bin \

