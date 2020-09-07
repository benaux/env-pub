#!/bin/sh
# Copyright (c) 2020 ben
# Licensed under the MIT license. 

HELP='Opens an URL in Chrome'
USAGE='--option=<required> <argument> [ -f | -g ] ([optional] | or <repeating>...) '

input="$1"

die () { echo "$@" 1>&2; exit 1; }
usage () { local app=$(basename $0); die "usage - $app: $USAGE"; }
realpath () { perl -MCwd -le 'print Cwd::realpath($ARGV[0])' $1; }
filename () { local n=$(basename $1); echo ${n%.*} ; }
fileext () { local n=$(basename $1); echo ${n##*.} ; }

[ -n "$input" ] || usage

while [ $# -gt 0 ]; do
   arg="$1"
   shift
   case "$arg" in
      -h|--help)
         echo "Help: $HELP" 1>&2
         usage
      ;;
      *)
         :
      ;;
  esac
done

input=$1

activate_chrome="$2"

if [ -n "$activate_chrome" ] ; then
osascript <<END
   tell application "Google Chrome"
      set URL of active tab of window 1 to "$input"
      activate
   end tell
END
else
osascript <<END
   tell application "Google Chrome"
      set URL of active tab of window 1 to "$input"
      --activate
   end tell
END
fi
