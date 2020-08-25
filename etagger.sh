#!/bin/bash

#------------------------------------------------------------------------------#
# This script will update any hacker tools defined within it when run.         #
#                                                                              #
# Created: 24 Aug 2020 Knightmare  v1.00  Initial version                      #
# Updated: 24 Aug 2020 Knightmare  v1.01  Removed a lot of fluff code          #
# Updated: 25 Aug 2020 Knightmare  v1.02  Fix typos, add TODO list in code     #
#------------------------------------------------------------------------------#

## Begin Pre-flight checks
## Dymanic Copyright Konami code
thisyear=`date +%Y`

## Default values
VERSION="1.02"
UPDATED="20200824"

## If we are not being asked to set up the tools, confirm all binaries exist
if [ "$clonerepo" = "0" ]; then
  ## Confirm we have all our needed binaries available $?=1 not found, 0 for found
  messages blue info "Performing Pre-flight checks, please wait..."
  for binary in cut curl grep wc; do
    location=`/usr/bin/which "$binary" > /dev/null 2>&1`
    if [ "$?" -eq 1 ]; then
      messages red error "Error: $binary command not found in path... cannot proceed"
      echo
      exit 0
    fi
  done
fi

## Test cURL version. Need version >= 7.68.0 in order to do on the fly ETag enumeration
## per https://daniel.haxx.se/blog/2019/12/06/curl-speaks-etag/
# TODO: Write code to make multi cURL version aware and command line option to do live check

## Help function. You'll need this...
function help {
  echo
  messages red  " `basename $0` - Script to use ETag values to enumerate Web app versions"
  messages cyan "     version: $VERSION COPYLEFT (L) Knightmare 2020-$thisyear"
  echo
  messages green "  Usage: `basename $0` [-h] [--help] [-e] [-f] [-p]"
  messages green "  e.g: `basename $0` -f"
  messages green "  `basename $0` -e to update only (does NOT compile)"
  messages green "  `basename $0` -f to invoke Test Card F mode (check colour output)"
  messages green "  `basename $0` -p Program to look up e.g 3cx, acornis, esxi, vc, etc"
  echo
  exit 1
}

## Mike Score would be so proud...
function messages () {
## logo Parameters: error, info, notify, warn
## colour parameters: blue, cyan, green, magenta, red, yellow
## example Usage: messages info green "Larkhall Blue"
outputcolour=$1
outputlogo=$2
outputtext=$3

case $outputlogo in
  error)
    outputlogo="[X]"
  ;;
  info)
    outputlogo="[o]"
  ;;
  notify)
    outputlogo="[*]"
  ;;
  warn)
    outputlogo="[!]"
  ;;
esac

## BBC Test Card F sans Bubbles the clown
ESC_SEQ="\x1b["
RESET=$ESC_SEQ"39;49;00m"

case $outputcolour in
  blue)
  blue="34;01m"
  echo -e "$ESC_SEQ$blue $outputlogo $outputtext $RESET"
  ;;
  cyan)
  cyan="36;01m"
  echo -e "$ESC_SEQ$cyan $outputlogo $outputtext $RESET"
  ;;
  green)
  green="32;01m"
  echo -e "$ESC_SEQ$green $outputlogo $outputtext $RESET"
  ;;
  magenta)
  magenta="35;01m"
  echo -e "$ESC_SEQ$magenta $outputlogo $outputtext $RESET"
  ;;
  red)
  red="31;01m"
  echo -e "$ESC_SEQ$red $outputlogo $outputtext $RESET"
  ;;
  yellow)
  yellow="33;01m"
  echo -e "$ESC_SEQ$yellow $outputlogo $outputtext $RESET"
  ;;
esac
}

## Get ready for the launch.... *Techno Music*
echo
messages red   "          ----------[    ETag Webapp Enumeration Tool    ]----------"
messages green "               -----[  Version: $VERSION  Updated: $UPDATED  ]-----"
echo

ETAG="$1"

if [[ "$ETAG" =~ "" ]]; then
    WEBAPPVERSION=`grep "$ETAG" etags.csv`
    WEBAPPFOUND=`echo "$WEBAPPVERSION" | wc -l`
fi

## Do some string matching on it
if [[ "$WEBAPPFOUND" -eq "0" ]]; then
  ## Did not find ETag so either it's a mistake or the ETag is not in the Databse
  messages red error "Sorry! $ETAG not found in database. If you are sure this is valid, please submit a PR on github"
else
  ## Found ETag, so use cut to parse into Variables, and print the result. This code is bad, but it works & I'm not
  ## GCHQ/NSA... So, ya know, live with it!
  ETAGAPP=`echo "$WEBAPPVERSION" | cut -f 1 -d \,`
  ETAGCSV=`echo "$WEBAPPVERSION" | cut -f 2 -d \,`
  ETAGVER=`echo "$WEBAPPVERSION" | cut -f 3 -d \,`
  ## I don't know if ETags can duplicate, don't think so, but one never knows...
  messages green notify "Found ETag: $ETAGCSV hit for Web app: $ETAGAPP Corresponding to build/version/firmware $ETAGVER"
  echo
fi

