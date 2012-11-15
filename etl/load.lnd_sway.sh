#!/bin/bash
. setup_cfg.sh

me=`basename $0`
file=(`echo $me | tr "." "\n"`)
flow_file=${PROJECT_RUN}/flow/${file[1]}.flow
cat $flow_file
