#!/bin/bash

SCRIPT_PATH="$(dirname "$0")"

GEN_CLIENT=${SCRIPT_PATH}/../Luban.ClientServer/Luban.ClientServer.dll
DEFINE_FILE=${SCRIPT_PATH}/../Language/__root__.xml
INPUT_DATA_PATH=${SCRIPT_PATH}/../Language
TEMPLATE_SEARCH_PATH=${SCRIPT_PATH}/CustomTemplates
OUTPUT=${SCRIPT_PATH}/../Output/ClientDefaultCode

while getopts "o:" opt; do
  case $opt in
    o)
      OUTPUT=$OPTARG
      ;;
  esac
done


dotnet ${GEN_CLIENT} -t ${TEMPLATE_SEARCH_PATH} -j cfg --\
 -d ${DEFINE_FILE} \
 -s client \
 --input_data_dir ${INPUT_DATA_PATH} \
 --output_code_dir ${OUTPUT}/SpecText \
 --gen_types code_cs_unity_bin \

