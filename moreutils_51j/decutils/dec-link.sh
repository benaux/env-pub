#!/bin/sh
# Copyright (c) 2020 ben
# Licensed under the MIT license. See License-MIT.txt in project root.

HELP=""
USAGE='<decimal dir> | <.dec file > | <dir with decfile>'

input="$1"

redir=$HOME/base/redir

resolve_script=$HOME/tools/morelibs/decimals/diroutput-from-decinput.sh

decinput=

die () { echo "$@" 1>&2; exit 1; }
warn () { echo "$@" 1>&2; }
usage () { [ -n "$1" ] && warn "$1"; local app=$(basename $0); die "usage - $app: $USAGE"; }
help () { warn "Help: $HELP" ; usage ; }
realpath () { perl -MCwd -le 'print Cwd::realpath($ARGV[0])' $1; }
filename () { local base=$1; local sep=$2; echo ${base%${sep}*} ; }
fileext () { local base=$1; local sep=$2; ext=${base##*${sep}} ; [ "$base" = "$ext" ] || echo $    ext ; }

[ -f "$resolve_script" ] || die "Err: script $resolve_script not exists"

[ -n "$input" ] || usage

while [ $# -gt 0 ]; do
   arg="$1"
   shift
   case "$arg" in
      -h|--help) help ;;
      -*) die "Err: invalid option use -h for help" ;;
      *) decinput="$arg" ;;
  esac
done

mkdir -p $redir

[ -d "$decinput" ] || [ -f "$decinput" ] || die "Err: dec dir $decinput not a folder and not a .dec file"

dirpath=$(sh $resolve_script $decinput)

input_base=$(basename $dirpath)
input_parent=$(dirname $dirpath)

if [ -d "$dirpath" ] ; then
   parent_base=$(basename $input_parent)
   parent_name=${parent_base%_*}

   linkname=${input_base}--$parent_name

   rm -f $redir/$linkname
   ln -s $dirpath $redir/$linkname
else
  die "Err: dirpath $dirpath not valid"
fi
