#!/bin/sh

this_script=$0

inp=$1


[ -n "$inp" ] || { echo "usage: file"; exit 2; }

inpdir=$(dirname $inp)
inpbase=$(basename $inp)
inpname=${inpbase%.*}

scmbase=$inpname.scm
scmout=$inpdir/.$scmbase


if [ -f "$scmout" ] ; then
  if [ "$this_script" -nt "$scmout" ]; then
    echo 'forced compilation because changed script'
      ~/tools/bin/mors $inp > "$scmout" 
  elif [ "$scmout" -nt "$inp" ]; then
    :
  else
    echo 'compile ...'
      ~/tools/bin/mors $inp > "$scmout" 
  fi
else
    echo 'compile ...'
      ~/tools/bin/mors $inp > "$scmout" 
fi

gosh -I ~/libs/gauche $scmout
