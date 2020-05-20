#!/bin/sh

input="$1"

if [ -n "$input" ] ; then
  if [ -f "$input" ] ; then
    baseinput=$(basename "$input")

    case "$baseinput" in
     *.html)
       echo /opt/local/bin/elinks "$input" > ~/out.txt
        ;;
     *)
       ~/tools/utils/v "$input"
        ;;
     esac
   fi
else
  exit 1
fi
