#!/bin/bash

SCRIPT_PATH="$(dirname "$0")"
GEN_CLIENT=${SCRIPT_PATH}/../Luban.Client/Luban.Client.dll
DEFINE_FILE=${SCRIPT_PATH}/../Common/Defines/__root__.xml
INPUT_DATA_PATH=${SCRIPT_PATH}/../Common
LANGUAGE_FILE=${SCRIPT_PATH}/../Language/language.xlsx
HOST=10.1.8.128
PORT=8899
OUTPUT=${SCRIPT_PATH}/../Output
LANGUAGE=zh-cn


while getopts "o:l:" opt; do
  case $opt in
    o)
      OUTPUT=$OPTARG
      ;;
    l)
      LANGUAGE=$OPTARG
      ;;
  esac
done



dotnet ${GEN_CLIENT} -h ${HOST} -p ${PORT} -l INFO -j cfg --\
 -d ${DEFINE_FILE} \
 -s server \
 --gen_types data_bin \
 --input_data_dir ${INPUT_DATA_PATH} \
 --output_data_dir ${OUTPUT}/Server \
 --output:exclude_tags skip \
 --l10n:timezone "Asia/Shanghai"

dotnet ${GEN_CLIENT} -h ${HOST} -p ${PORT} -l INFO -j cfg --\
 -d ${DEFINE_FILE} \
 -s client \
 --gen_types data_bin \
 --input_data_dir ${INPUT_DATA_PATH} \
 --output_data_dir ${OUTPUT}/${LANGUAGE} \
 --output:exclude_tags skip \
 --l10n:input_text_files ${LANGUAGE_FILE} \
 --l10n:text_field_name ${LANGUAGE} \
 --l10n:output_not_translated_text_file ${SCRIPT_PATH}/../NotLocalized_${LANGUAGE}.txt \
 --l10n:timezone "Asia/Shanghai"
