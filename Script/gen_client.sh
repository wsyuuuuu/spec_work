#!/bin/zsh

cd "$(dirname "$0")"

GEN_CLIENT=../Luban.ClientServer/Luban.ClientServer.dll
GEN_TYPES=code_cs_unity_bin,data_bin
OUTPUT=../Output

while getopts "o:" opt; do
  case $opt in
    o)
      OUTPUT=$OPTARG
      ;;
  esac
done



dotnet ${GEN_CLIENT} -j cfg --\
 -d ../Common/defines/__root__.xml \
 --input_data_dir ../Common \
 --output_data_dir ${OUTPUT}/DataCommon \
 --output_code_dir ${OUTPUT}/SpecCommon \
 --output:exclude_tags skip \
 --gen_types ${GEN_TYPES} \
 -s client \
 --l10n:input_text_files ../Language/language.xlsx \
 --l10n:text_field_name text_zh_cn \
 --l10n:output_not_translated_text_file NotLocalized_CN.txt \
 # --l10n_timezone "Asia/Shanghai"


