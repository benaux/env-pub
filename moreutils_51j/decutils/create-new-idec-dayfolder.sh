#!/bin/sh
# Copyright (c) 2020 ben
# Licensed under the MIT license. See License-MIT.txt in project root.

HELP=""
USAGE="<dir> <user-sig>"

input="$1"

dir_input= user_sig=

tools=$HOME/tools

redir=$HOME/base/redir

day_stamp_script=$tools/moreutils/stamputils/day-sec-base26.sh

declibs=$tools/morelibs/declib
dec_from_decinput=$declibs/dec-from-decinput.sh
decoutput_from_dirinput=$declibs/decoutput-from-dirinput.sh

cwd=$(pwd)
cwd_base=$(basename $cwd)
die () { echo "$@" 1>&2; exit 1; }
warn () { echo "$@" 1>&2; }
usage () { [ -n "$1" ] && warn "$1"; local app=$(basename $0); die "usage - $app: $USAGE"; }
help () { warn "Help: $HELP" ; usage ; }
realpath () { perl -MCwd -le 'print Cwd::realpath($ARGV[0])' $1; }
filename () { local base=$1; local sep=$2; echo ${base%${sep}*} ; }
fileext () { local base=$1; local sep=$2; ext=${base##*${sep}} ; [ "$base" = "$ext" ] || echo $ext ; }

[ -n "$input" ] || usage
[ -f "$decoutput_from_dirinput" ] || die "Err: missing script $decoutput_from_dirinput"
[ -f "$dec_from_decinput" ] || die "Err: missing script $dec_from_decinput"
[ -f "$day_stamp_script" ] || die "Err: missing script $day_stamp_script"

while [ $# -gt 0 ]; do
   arg="$1"
   shift
   case "$arg" in
      -h|--help) help ;;
      -*) die "Err: invalid option use -h for help" ;;
      *) 
        dir_input="$arg" 
        user_sig="$1"
        shift
        ;;
  esac
done

[ -n "$dir_input" ] || usage "no dir input"
[ -n "$user_sig" ] || usage "no user-sig"

dir_base=$(basename $dir_input)

parent_dir=$(dirname $dir_input)
parent_path=$(realpath $parent_dir)

[ -d "$parent_path" ] || die "Err: parent dir path $parent_path is invalid"

decitem=$(sh $decoutput_from_dirinput $parent_path)
[ -e "$decitem" ] || die "Err: parent dir path $decitem is invalid"

dec=$(sh $dec_from_decinput $decitem)
[ -n "$dec" ] || die "Err: could not extract a dec from decitem $decitem "

thisdec=${dec}0

daystamp=$(sh $day_stamp_script)
[ -n "$daystamp" ] || die "Err: could not retrieve daystamp"

daydir="$parent_path"/"$dir_base"_${daystamp}-${user_sig}_${thisdec}

mkdir -p  "$daydir"
printf "$daydir"
