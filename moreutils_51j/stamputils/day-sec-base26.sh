#!/bin/sh

HELP='A stamp with y:m:d:h:m:s, optionally with a user id'
USAGE='[date.time YearMonthDay.HourMinuteSecond]'

arg=$1

die () { echo $@; exit 1; }

base10tobase26=$HOME/tools/moreutils/morelibs/math/base10tobase26.pl
[ -f "$base10tobase26" ] || die "Err: script base10tobase26 missing"

sec_time=
if [ -n "$arg" ] ; then
  case "$arg" in
   -h|--help) die "help: $HELP\nusage: $USAGE" ;;
   *)
     sec_time="$arg"
     ;;
 esac
fi

year_month_day= h_min_sec=
if [ -n "$sec_time" ] ; then
   year_month_day=${sec_time%%.*}
   h_min_sec=${sec_time##*.}
else
   year_month_day=$(date +"%Y%m%d")
   h_min_sec=$(date +"%H%M%S")
fi

case "$year_month_day" in
   [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]) : ;;
   *) die "Err: date input not valid" ;;
esac

case "$h_min_sec" in
   [0-9][0-9][0-9][0-9][0-9][0-9]) : ;;
   *) die "Err: time input not valid" ;;
esac

hms_base=$(/usr/bin/env perl $base10tobase26 $h_min_sec)

if [ -n "$hms_base" ] ; then
   echo "$year_month_day$hms_base"
else
   die "Err: hms missing"
fi
