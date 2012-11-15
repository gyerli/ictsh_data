#!/bin/bash


if [ -n "$1" ]
then
  table=$1
else  
  echo table name is not specified on command-line.
  exit 1
fi

if [ -n "$2" ]
then
  file=$2
else  
  echo file name is not specified on command-line.
  exit 1
fi

. ../setup_cfg.sh
ts=`date "+%Y%m%d_%H%M%S"`
table=$1
file=$2
output=${PROJECT_TEMP}/$1_$ts.tmp
cat > ${output} << EOF
copy ${table} 
from '${PROJECT_INTAKE}/${file}'
with
delimiter '|' 
CSV 
header 
EOF
