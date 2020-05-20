#!/bin/sh

HELP='A stamp with c: y:m:d:h:min, output example "0afkjkl"'
USAGE='[minute stamp in  form of ymdh, eg. 2020-04-18.22:50]'

arg="$1"

die () { echo $@; exit 1; }

morelib=$HOME/tools/moreutils/morelibs
base10tobase26=$morelib/math/base10tobase26.pl
[ -f "$base10tobase26" ] || die "Err: script base10tobase26 missing"


minute_stamp= century_num= 
if [ -n "$arg" ] ; then
  case "$arg" in
   -h|--help) 
     die "help: $HELP\nusage: $USAGE" 
     ;;
  *-*-*.*:*) 
   datetime_input="$arg" 
   date_part=${datetime_input%.*}

   time_part=${datetime_input##*.}
   hour=${time_part%%:*}
   minute=${time_part##*:}

   day=${date_part##*-}
   year=${date_part%%-*}
   monthday=${date_part#*-}
   month=${monthday%%-*}

   decade="${year:2:3}"
   century_num="${year:1:1}"

   for d in $decade $month $day $hour $minute ; do
     case "$d" in
       [0-9][0-9]) : ;;
       *) die "invalid date format with input $datetime_input" ;;
     esac
   done

   # base26 doesnt encode 00 well
   #decade_plus_ten=$(perl -e 'print + $ARGV[0] + 10' $decade)

   minute_stamp=$decade$month$day$hour$minute
   ;;
 *)
   minute_stamp="${arg:2}"
   century_num="${arg:1:1}"

   #minute_stamp=$century_num$decade_stamp
   ;;
 esac
else
   minute_stamp=$(date +"%y%m%d%H%M")
   cent=$(date +"%C")
   century_num="${cent:1}"
   #echo $cent_num$minute_stamp
   #minute_base=$(/usr/bin/env perl $base10tobase26 $minute_stamp)
   #echo mm $minute_base
fi

case "$minute_stamp" in
  [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]) : ;;
  *) die "Err:invalid timestamp $minute_stamp ($decade $month $day $hour $minute) ";;
esac
case "$century_num" in
  [0-9]) : ;;
  *) die "Err:invalid century number ";;
esac


minute_base=$(/usr/bin/env perl $base10tobase26 $minute_stamp)

echo $century_num$minute_base
