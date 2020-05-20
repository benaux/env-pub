#!/bin/sh

HELP='A stamp with y:m:d:h:m, optionally with a user id'
USAGE='[-u|--user [userid]]'

arg=$1

function die () { echo $@; exit 1; }



userid=
if [ -n "$arg" ] ; then
  case "$arg" in
   -h|--help) die "help: $HELP\nusage: $USAGE" ;;
   -u|--user)
     if [ -n "$2" ] ; then
       userid=$2
     else
      userid=${USER::2}
     fi
     [ -n "$userid" ] || die "err: could not detect user id" 
      ;;
 esac
fi

stamp_minute=$(date +"%Y%m%d%H%M")

if [ -n "$userid" ] ; then
   echo "$userid$stamp_minute"
else
   echo "$stamp_minute"
fi

