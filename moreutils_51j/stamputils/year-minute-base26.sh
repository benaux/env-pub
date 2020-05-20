#!/bin/bash

HELP='A base26 encoded stamp of y:m:d:h:m:s, optionally with userid'
USAGE='[-u|--user [userid]]'

arg=$1

function die () { echo $@; exit 1; }

base26=$HOME/tools/moreutils/numericutils/base10tobase26.sh

[ -f "$base26" ] || die "Err:cannot find base26 in $base26"

stamp=
if [ -n "$arg" ] ; then
  case "$arg" in
   -h|--help) die "help:  $HELP \nusage: $USAGE" ;;
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

stamp_year=$(date +"%Y")
stamp_minute=$(date +"%m%d%H%M")

# why adding 10 millions
# months can have a leading 0 which is not encoded by base26
stamp_millions=$(perl -e 'print 10000000 + $ARGV[0]' $stamp_minute)

stamp_base=$(sh $base26 $stamp_millions)
#stamp_base=$(python3 $base_crock $stamp_minute)
[ -n "$stamp_base" ] || die "Err: no stamp-base in $stamp_base"

datestamp=$stamp_year$stamp_base
#datestamp=$stamp_base


if [ -n "$userid" ] ; then
   echo "$userid$datestamp"
else
   echo "$datestamp"
fi
#echo bk$(sh $base26 $stamp_minute)

