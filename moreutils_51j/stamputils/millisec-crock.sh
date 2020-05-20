#!/bin/sh

HELP='Geneare an id with user id and a crockford version of date stamp'
USAGE='[-s|--sec]'

arg=$1

function die () { echo $@; exit 1; }

lib=$HOME/tools/moreutils/lib

stamp_crock_script=$lib/math/base-crockford.py
[ -f "$stamp_crock_script" ] || die "Err:cannot find stamp-crock in $stamp_crock_script"

milliseconds=$lib/date/milliseconds.pl
[ -f "$milliseconds" ] || die "Err:cannot find milliseconds.pl in $milliseconds"

py=$(which python3)
[ -n "$py" ] || die "Err: no python interp"
[ -f "$py" ] || die "Err: no python interp"

userid=$arg

stamp=
if [ -n "$arg" ] ; then
  case "$arg" in
   -h|--help) die "help: $HELP" ;;
   -u|--user) userid=${USER::2} ;;
 esac
fi

#stamp_minute=$(date +"%Y%m%d%H%M")

millis=$(/usr/bin/env perl $milliseconds)

stamp_crock=$($py $stamp_crock_script $millis)

[ -n "$stamp_crock" ] || die "Err: no stamp-crock in $stamp_crock"

if [ -n "$userid" ] ; then
   echo "$userid-$stamp_crock"
else
   echo "0$stamp_crock"
fi

