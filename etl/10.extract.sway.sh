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

ruby ${PROJECT_RUN}/sway_areas.rb ${PROJECT_SRC}/sway/get_areas.xml ${PROJECT_INTAKE}/sway/areas.dat
ruby ${PROJECT_RUN}/sway_competitions.rb ${PROJECT_SRC}/sway/get_competitions.xml ${PROJECT_INTAKE}/sway/competitions.dat

# Done
exit 0
