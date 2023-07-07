#!/bin/bash

source $(dirname "$0")/defines.properties

DEFINE_FILE=${REPO_ROOT_PATH}/.defines/__common__.xml
INPUT_DATA_DIR=${REPO_ROOT_PATH}/Common
DATA_PATH=${SCRIPT_PATH}/../Common
INPUT_TEXT_FILE=${REPO_ROOT_PATH}/Language/language.xlsx


# -h ${LUBAN_SERVER_HOST} -p ${LUBAN_SERVER_PORT} -l INFO

# 生成服务端Spec数据
dotnet ${LUBAN_CLIENT_SERVER_DLL} -j cfg --\
 -d ${DEFINE_FILE} \
 -s server \
 --gen_types data_bin \
 --input_data_dir ${INPUT_DATA_DIR} \
 --output_data_dir ${SERVER_SPEC_DATA_OUTPUT} \
 --output:exclude_tags skip \
 --l10n:timezone "Asia/Shanghai"



# 生成客户端Spec数据
for LANGUAGE in ${LANGUAGE_CODES[*]}; do
  dotnet ${LUBAN_CLIENT_SERVER_DLL} -j cfg --\
   -d ${DEFINE_FILE} \
   -s client \
   --gen_types data_bin \
   --input_data_dir ${INPUT_DATA_DIR} \
   --output_data_dir ${CLIENT_SPEC_DATA_OUTPUT}/Common/${LANGUAGE} \
   --output:exclude_tags skip \
   --l10n:input_text_files ${INPUT_TEXT_FILE} \
   --l10n:text_field_name ${LANGUAGE} \
   --l10n:output_not_translated_text_file ${NOT_LOCALIZED_PATH}/Common_${LANGUAGE}.txt \
   --l10n:timezone "Asia/Shanghai"
done
