#!/bin/bash

SCRIPT_PATH="$(dirname "$0")"

GEN_CLIENT=${SCRIPT_PATH}/../Luban.ClientServer/Luban.ClientServer.dll
DEFINE_FILE=${SCRIPT_PATH}/../ClientDefault/__root__.xml
INPUT_DATA_PATH=${SCRIPT_PATH}/../ClientDefault
LANGUAGE_FILE=${SCRIPT_PATH}/../Language/language.xlsx
OUTPUT=${SCRIPT_PATH}/../Output/ClientDefaultData

while getopts "o:" opt; do
  case $opt in
    o)
      OUTPUT=$OPTARG
      ;;
  esac
done

LANGUAGES=(zh-cn en)

for LANGUAGE in ${LANGUAGES[*]}; do

dotnet ${GEN_CLIENT} -j cfg --\
 -d ${DEFINE_FILE} \
 -s client \
 --input_data_dir ${INPUT_DATA_PATH} \
 --output_data_dir ${SCRIPT_PATH}/../Temp \
 --gen_types data_bin \
 --l10n:input_text_files ${LANGUAGE_FILE} \
 --l10n:text_field_name ${LANGUAGE} \
 --l10n:output_not_translated_text_file ${SCRIPT_PATH}/../NotLocalized_${LANGUAGE}_Default.txt \


mv ${SCRIPT_PATH}/../Temp/common_defaulttext.bytes ${OUTPUT}/default_${LANGUAGE}_text.bytes

done

rm -rf ${SCRIPT_PATH}/../Temp
