#!/bin/bash
. setup_cfg.sh

if [ -n "$1" ]
then
  table=$1
else  
  table="areas"
#  echo table name is not specified on command-line.
#  exit 1
fi

if [ -n "$2" ]
then
  file=$2
else  
  file="areas.dat"
#  echo file name is not specified on command-line.
#  exit 1
fi

me=`basename $0`
run_file=(`echo $me | tr "." "\n"`)
flow_file=${PROJECT_RUN}/flow/${run_file[1]}.flow

ts=`date "+%Y%m%d_%H%M%S"`
output=${PROJECT_TEMP}/$file_$ts.tmp
cat > ${output} << EOF
copy ${table} 
from '${PROJECT_INTAKE}/sway/${file}'
with
delimiter '|' 
CSV 
header 
EOF

LND_SWAY=lnd_sway
psql -U ${DB_USER} -w -d ${LND_SWAY} -c "TRUNCATE TABLE areas" 
psql -U ${DB_USER} -w -d ${LND_SWAY} -f ${output} 
