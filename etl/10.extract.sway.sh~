#!/bin/bash
################################################################################
# Name: extract.sh
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

#===================================================================
s_get_word_delim()    #Returns the word at position in list
#===================================================================
# Arg_1 = position
# Arg_2 = delim
# Arg_n = list
{
   VAR1=$(echo $@ | cut -f2- -d$2  | cut -f$1 -d$2 )
        echo $VAR1
}


################################################################################
# Create areas.dat file
# ---------------------
# read from preprapared XML from SWAY and create intake file_out
################################################################################
Areas() {
ruby ${PROJECT_RUN}/sway_areas.rb ${PROJECT_SRC}/sway/get_areas.xml ${PROJECT_INTAKE}/sway/areas.dat
}

################################################################################
# Create competitions.dat file
# ----------------------------
#Ruby code sway_competitions.rb will extract competitions data from SWAY and creates intake file
################################################################################
Competitions() {
ruby ${PROJECT_RUN}/sway_competitions.rb ${PROJECT_INTAKE}/sway/competitions.dat
}


################################################################################
# Create competition_urls file
# ----------------------------
# Builds competition URL string from SWAY parameters, replace spaces and 
# other characters with "-"
#
# Used parameters;
# ----------------
# area_name
# country_code 
# competition_name
################################################################################
CompetitionURLs() {
ts=`date "+%Y%m%d_%H%M%S"`
sql=${PROJECT_TEMP}/competition_urls_$ts.tmp
file_out=/usr/local/share/tmp/competition_urls_$ts.dat
file=${PROJECT_INTAKE}/sway/competition_urls.dat
cat > ${sql} << EOF
copy (
select 
  a.competition_id,
  a.loc || '/' || a.a_name || '/' || a.competition_name url
from (select 
	c.competition_id,
	a.area_name,
	c.name,
	case 
	  when a.country_code is null then 'international'
	  else 'national'
	end loc,
	replace(replace(lower(a.area_name),' ','-'),'/','') a_name,
	replace(replace(replace(replace(replace(lower(c.name),' ','-'),'/',''),'(',''),')',''),'.','') competition_name
       from competitions c
    inner join areas a on (c.area_id = a.area_id)
   ) a 
) to '${file_out}'
delimiter '|'
EOF
psql -U ${DB_USER} -w -d lnd_sway -f ${sql}
cp ${file_out} ${file}
}

################################################################################
# Create Season Matches file
# ----------------------------
# Ruby code sway_season_matches.rb will extract match data from SWAY and 
# creates intake file. Script reads from competition_urls table and input URL to
# Ruby code.
################################################################################
SeasonMatches() {

ts=`date "+%Y%m%d_%H%M%S"`
sql=${PROJECT_TEMP}/competition_url_sql_$ts.tmp
db="lnd_sway"

echo "Landing Database is ${db}"

cat > ${sql} << EOF
SELECT competition_id, url
  FROM competition_urls cu
 WHERE cu.competition_id IN ( SELECT competition_id
			       FROM competition_etls
			      WHERE is_included = 'T'
			        AND is_url_valid = 'T' 
			        AND is_competitions_etl_completed = 'F');
EOF

URLS=$(psql -U ${DB_USER} -w -d ${db} -f ${sql} -t -A)

for URL in $URLS
do

COMPETITION_ID=$(s_get_word_delim 1 "|" "$URL" )
C_URL=$(s_get_word_delim 2 "|" "$URL")
LOC=$(s_get_word_delim 1 "/" "$C_URL")
AREA=$(s_get_word_delim 2 "/" "$C_URL")
COMPETITION_NAME=$(s_get_word_delim 3 "/" "$C_URL")
R_URL=http://www.soccerway.com/${C_URL}

status=`wget -q ${R_URL} > /dev/null`

if [ $? -eq 0 ]; then
file_out=/usr/local/share/tmp/season_matches_${COMPETITION_ID}_${LOC}_${AREA}_${COMPETITION_NAME}_${ts}.dat
echo "Executing ${PROJECT_RUN}/sway_season_matches.rb ${COMPETITION_ID} ${R_URL} ${file_out}"
ruby ${PROJECT_RUN}/sway_season_matches.rb ${COMPETITION_ID} ${R_URL} ${file_out}
else
echo "URL \"$R_URL\" is invalid"
psql -U ${DB_USER} -w -d ${db} -c "update competition_etls set is_url_valid = false where competition_id = ${COMPETITION_ID};"
fi

done
}


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
longopts=help,ChkSyntax

cmdline=$(getopt -a --longoptions=$longopts --options=+$shortopts -- "$@") ||
    Syntax 1 "Unknown command line option."
eval set -- "$cmdline"

while true
do
    case $1 in
      (-h|--help) Syntax 0;;
      (--ChkSyntax) ChkSyntax=Y;;
      (--) shift; break;;
    esac
    shift
done

################################################################################
# Determine command line consequences
################################################################################
# Check for stoopid user errors

# Exit after syntax check.
[[ -n $ChkSyntax ]] && exit 0

################################################################################
# Duit tuit
################################################################################
# Do the dirty deed
. setup_cfg.sh
clear

#Areas
#Competitions
#CompetitionURLs
#SeasonMatches
ruby ${PROJECT_RUN}/sway_season_matches.rb 1 http://www.soccerway.com/national/argentina/argentino-a argentina.dat

# Done
exit 0
