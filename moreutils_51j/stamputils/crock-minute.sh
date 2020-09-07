#!/bin/sh

HELP='A stamp with c: y:m:d:h:min, output example "0afkjkl"'
USAGE='[minute stamp in  form of ymdh, eg. 2020-04-18.22:50]'

arg="$1"

die () { echo $@ 1>&2; exit 1; }

#morelibs=$HOME/tools/morelibs
#base10tobase26=$morelibs/mathlib/base10tobase26.pl
#[ -f "$base10tobase26" ] || die "Err: script base10tobase26 missing"

perl -M'Encode::Base32::Crockford "base32_encode"' -e 1 || die 'Err: please install "perl -MEncode::Base32::Crockford base32_encode" -e 1'



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

   case "$year" in 
     [0-9][0-9][0-9][0-9]) : ;;
     *) die "Err: invalid year format" ;;
   esac

   for d in $month $day $hour $minute ; do
     case "$d" in
       [0-9][0-9]) : ;;
       *) die "invalid date format with input $datetime_input" ;;
     esac
   done

   # base26 doesnt encode 00 well
   #decade_plus_ten=$(perl -e 'print + $ARGV[0] + 10' $decade)

   minute_stamp=$century_decade$month$day$hour$minute
   ;;
 *)
   minute_stamp="${arg}"
   ;;
 esac
else
   minute_stamp=$(date +"%Y%m%d%H%M")
fi

case "$minute_stamp" in
  [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]) : ;;
  *) die "Err:invalid timestamp $minute_stamp ($year $month $day $hour $minute) ";;
esac


#base32_encode () {
perl -M'Encode::Base32::Crockford "base32_encode"' -e 'print lc((base32_encode($ARGV[0])))' $minute_stamp

#minute_base=$(/usr/bin/env perl $base10tobase26 $minute_stamp)

