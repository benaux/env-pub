#!/bin/sh

HELP='A stamp with y:m:d:h:m:s, optionally with a user id'
USAGE='[-u|--user [userid]]'

arg=$1

die () { echo $@; exit 1; }

morelib=$HOME/tools/moreutils/morelib
base10tobase26=$morelib/math/base10tobase26.pl
[ -f "$base10tobase26" ] || die "Err: script base10tobase26 missing"

milliseconds=$morelib/date/milliseconds.pl
[ -f "$milliseconds" ] || die "Err: script base10tobase26 missing"

userid= dateinput=
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

day=$(date +"%Y%m%d%H")
hour_min_sec=$(date +"%M%S")

msec_stamp=$(/usr/bin/env perl $milliseconds)

msec=${msec_stamp##*.}

numstring=$hour_min_sec$msec

ms_base=$(/usr/bin/env perl $base10tobase26 $numstring)

if [ -n "$userid" ] ; then
   echo "${userid}0$year_month_day$ms_base"
else

  echo $day$ms_base
   #echo $day$ms_base
fi
