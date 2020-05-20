#!/bin/sh


infolder=$1
get_id=$2

get_id_default=$HOME/tools/moreutils/decimalutils/dec-id.sh

die () { echo $@; exit 1; }

[ -d "$infolder" ] || infolder=$(pwd)

[ -f "$get_id" ] || get_id=$get_id_default
[ -f "$get_id" ] || die "Err: no script get_id in $get_id"

realfolder=$(perl -MCwd -le 'print Cwd::realpath($ARGV[0])' $infolder)
parentdir=$(dirname $realfolder)

for d in $infolder/*; do
  [ -d "$d" ] || continue
  bd=$(basename $d)
  dd=$(dirname $d)


  name=$(sh $get_id $d)
  if [ "$?" = "0" ] ; then
    if [ -n "$name" ] ; then
      mv $d $realfolder/$name
   fi
  fi
done


