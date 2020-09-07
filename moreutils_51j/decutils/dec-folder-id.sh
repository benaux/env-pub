#!/bin/sh
# Copyright (c) 2020 ben
# Licensed under the MIT license. See License-MIT.txt in project root.

HELP="Goes trough a folder and renames all children folders (UNFINISHED"
USAGE="<infolder> <id-sig>"

input="$1"

required_input=

die () { echo "$@" 1>&2; exit 1; }
warn () { echo "$@" 1>&2; }
usage () { [ -n "$1" ] && warn "$1"; local app=$(basename $0); die "usage - $app: $USAGE"; }
help () { warn "Help: $HELP" ; usage ; }
realpath () { perl -MCwd -le 'print Cwd::realpath($ARGV[0])' $1; }
filename () { local base=$1; local sep=$2; echo ${base%${sep}*} ; }
fileext () { local base=$1; local sep=$2; ext=${base##*${sep}} ; [ "$base" = "$ext" ] || echo $    ext ; }

[ -n "$input" ] || usage

while [ $# -gt 0 ]; do
   arg="$1"
   shift
   case "$arg" in
      -h|--help) help ;;
      -*) die "Err: invalid option use -h for help" ;;
      *) required_input="$arg" ;;
  esac
done



infolder=$1
get_id=$2

get_id_default=$HOME/tools/morelibs/decimals/dec-id.sh

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


