#!/bin/sh

input="$1"

lib=$HOME/libs/gauche

if [ -n "$input" ] ; then
  if [ -d "$lib" ] ; then
   gosh -I "$lib" "$input"
  else
   gosh "$input"
  fi
else
  rlwrap  /usr/bin/env gosh -I "$lib"
fi
