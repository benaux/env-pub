#!/bin/sh

HELP='A stamp with y:m:d:h:m:s, optionally with a user id'
USAGE='[-u|--user [userid]]'

arg=$1

die () { echo $@; exit 1; }

base10tobase26=$HOME/tools/moreutils/morelibs/math/base10tobase26.pl
[ -f "$base10tobase26" ] || die "Err: script base10tobase26 missing"

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


year_month=$(date +"%Y%m")
day_h_min_sec=$(date +"%d%H%M%S")

#echo Vyer month $year_month
#echo d h min sec $day_h_min_sec

hms_base=$(/usr/bin/env perl $base10tobase26 $day_h_min_sec)


if [ -n "$userid" ] ; then
   echo "${userid}0$year_month_day$hms_base"
else
   echo "$year_month$hms_base"
fi
