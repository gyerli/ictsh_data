#!/bin/bash
################################################################################
# Name: load.sh
# Purpose: 
# $Id$
#
# Description:
#   <Be thorough, but terse>
#-------------------------------------------------------------------------------
# Usage:
#   Use --help for usage.
################################################################################

# Work around some bashisms
shopt -s extglob xpg_echo

# Set up primitive debugger.
i_am=${0##*/} PS4='-$i_am:$LINENO+'
[[ $setxv = @(x*|*$i_am*) ]] && set -x; [[ $setxv = @(v|v*$i_am*) ]] && set -xv

# $i_am may be modified in functions.  This preserves the original value.
OrigIAm=$i_am

################################################################################
# Syntax()
################################################################################
Syntax() {
# Check if a message was specified.
[[ -n $2 ]] && {
    # Print the message.
    echo "\n$2"
} >&2

# Check if this is an error condition.
[[ $1 -ne 0 ]] && {
    echo
    # Print the command line.
    echo "Command line:"
    echo "$OrigIAm $CmdLine"
    echo

    # Print the "--help" message.
    echo "For Syntax, use \"$OrigIAm --help\""
    echo

    # Bail.
    exit $1
} >&2

echo "
Usage:  $i_am [--help]
    --help: Display this message.

The purpose of $i_am is to make life easier for shell scripters.

Notes:
"

exit $1
} # Syntax()

################################################################################
# Initialization
################################################################################
# Initialize command line variables.  Source function files.

# Snag the command line.  This is used in the Syntax function.
. f_CmdLine

# Initialize variables.
ChkSyntax=""

################################################################################
# Parse the command line
################################################################################
# Determine which options are specified on the command line.

# A colon after a shortoption or longoption indicates the option takes an
# argument.  Shortoptions are concatenated (e.g. hab:c) while longoptions are
# comma-delimited (e.g. help,alpha,bravo:,charlie).  Note:  the -a allows the
# longoptions to work with a single dash.
shortopts=h
longopts=help,ChkSyntax,table:,file:,src:,truncate

cmdline=$(getopt -a --longoptions=$longopts --options=+$shortopts -- "$@") ||
    Syntax 1 "Unknown command line option."
eval set -- "$cmdline"

while true
do
    case $1 in
      (-h|--help) Syntax 0;;
      (--ChkSyntax) ChkSyntax=Y;;
      (--table) table=$2; shift;;
      (--file) file=$2; shift;;
      (--src) src=$2; shift;;
      (--truncate) truncate=Y;;
      (--) shift; break;;
    esac
    shift
done

################################################################################
# Determine command line consequences
################################################################################
# Check for stoopid user errors
[[ -z $file ]] && Syntax 1 "file name is empty"
[[ -z $table ]] && Syntax 1 "table name is empty"
[[ -z $src ]] && Syntax 1 "source system code is empty"

# Exit after syntax check.
[[ -n $ChkSyntax ]] && exit 0

################################################################################
# Duit tuit
################################################################################
# Do the dirty deed
. setup_cfg.sh
clear
echo "Landing Database is \"lnd_${src}\""
if [[ -f ${PROJECT_INTAKE}/${src}/${file} ]];
then 
  echo "Found intake data file \"${PROJECT_INTAKE}/${src}/${file}\""
else
  echo "Intake file \"${PROJECT_INTAKE}/${src}/${file}\" is not found"
  exit 1
fi
RECS=0
RECS=$(psql -U ${DB_USER} -w -d lnd_${src} -A -t <<! 2>/dev/null
select 1 from pg_tables 
where schemaname='public'
and tablename='${table}';
!
)
if [[ $RECS -eq 1 ]];
then
  echo "Found target table \"${table}.\""  
else
  echo "Target table \"${table}\" is not found."
  exit 1
fi

echo "=============================================="

me=`basename $0`
run_file=(`echo $me | tr "." "\n"`)
flow_file=${PROJECT_RUN}/flow/${run_file[1]}.flow

ts=`date "+%Y%m%d_%H%M%S"`
output=${PROJECT_TEMP}/$file_$ts.tmp
cat > ${output} << EOF
copy ${table} 
from '${PROJECT_INTAKE}/${src}/${file}'
with
delimiter '|' 
CSV 
header 
EOF

LND_DB="lnd_${src}"
if [[ -n $truncate ]] 
  then psql -U ${DB_USER} -w -d ${LND_DB} -c "TRUNCATE TABLE ${table}" 
fi
psql -U ${DB_USER} -w -d ${LND_DB} -f ${output} 

exit 0
