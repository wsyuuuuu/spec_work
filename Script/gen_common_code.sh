#!/bin/bash

SCRIPT_PATH="$(dirname "$0")"
GEN_CLIENT=${SCRIPT_PATH}/../Luban.ClientServer/Luban.ClientServer.dll
DEFINE_FILE=${SCRIPT_PATH}/../Common/Defines/__root__.xml
INPUT_DATA_PATH=${SCRIPT_PATH}/../Common
OUTPUT=${SCRIPT_PATH}/../Output
SERVER=client
GEN_TYPES=code_java_bin


while getopts "o:s:" opt; do
  case $opt in
    o)
      OUTPUT=$OPTARG
      ;;
    s)
      SERVER=$OPTARG
      ;;
  esac
done


if [[ ${SERVER} -eq "client" ]]; then
  GEN_TYPES=code_cs_unity_bin
fi


dotnet ${GEN_CLIENT} -j cfg --\
 -d ${DEFINE_FILE} \
 -s ${SERVER} \
 --gen_types ${GEN_TYPES} \
 --input_data_dir ${INPUT_DATA_PATH} \
 --output_code_dir ${OUTPUT}/SpecCommon \
