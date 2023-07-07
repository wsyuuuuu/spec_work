#!/bin/bash

source $(dirname "$0")/defines.properties

DEFINE_FILE=${REPO_ROOT_PATH}/.defines/__common__.xml
INPUT_DATA_DIR=${REPO_ROOT_PATH}/Common
DATA_PATH=${SCRIPT_PATH}/../Common


dotnet ${LUBAN_CLIENT_SERVER_DLL} -j cfg --\
 -d ${DEFINE_FILE} \
 -s server \
 --gen_types code_java_bin \
 --input_data_dir ${INPUT_DATA_DIR} \
 --output_code_dir ${SERVER_SPEC_CODE_OUTPUT} \


dotnet ${LUBAN_CLIENT_SERVER_DLL} -j cfg --\
 -d ${DEFINE_FILE} \
 -s client \
 --gen_types code_cs_unity_bin \
 --input_data_dir ${INPUT_DATA_DIR} \
 --output_code_dir ${CLIENT_SPEC_CODE_OUTPUT}/Common \
