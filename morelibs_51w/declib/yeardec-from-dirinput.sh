#!/bin/sh
# Copyright (c) 2020 ben
# Licensed under the MIT license. See License-MIT.txt in project root.

HELP="Return deced folder"
USAGE="<input-dir><usersig>"

input="$1"

input_dir=
input_usersig=


heredir=$(dirname $0)
decoutput_from_dirinput=$heredir/decoutput-from-dirinput.sh
dec_from_decinput=$heredir/dec-from-decinput.sh

year_minute_base26=$HOME/tools/moreutils/stamputils/year-minute-base26.sh

die () { echo "$@" 1>&2; exit 1; }
warn () { echo "$@" 1>&2; }
usage () { [ -n "$1" ] && warn "$1"; local app=$(basename $0); die "usage - $app: $USAGE"; }
help () { warn "Help: $HELP" ; usage ; }
realpath () { perl -MCwd -le 'print Cwd::realpath($ARGV[0])' $1; }
filename () { local base=$1; local sep=$2; echo ${base%${sep}*} ; }
fileext () { local base=$1; local sep=$2; ext=${base##*${sep}} ; [ "$base" = "$ext" ] || echo $ext ; }

[ -n "$input" ] || usage

[ -f "$decoutput_from_dirinput" ] || die "Err: $heredir/decoutput-from-dirinput.sh not here"
[ -f "$dec_from_decinput" ] || die "Err: $heredir/dec-from-decinput.sh not here"
[ -f "$year_minute_base26" ] || die "Err: $year_minute_base26"

while [ $# -gt 0 ]; do
   arg="$1"
   shift
   case "$arg" in
      -h|--help) help ;;
      -*) die "Err: invalid option use -h for help" ;;
      *) 
        input_dir="$arg" 
        input_usersig=$1
        shift
        ;;
  esac
done

[ -n "$input_dir" ] || die "Err no input dir"
[ -n "$input_usersig" ] || die "Err no usersig"

yearminute=$(sh $year_minute_base26)
[ -n "$yearminute" ] || die "Err no yearminute"

realdir=$(realpath $input_dir)
thisbase=$(basename $realdir)
thislast=${thisbase##*_}

case "$thislast" in
   [1-9][1-9]|[1-9][1-9][a-z]*) # 66 66a 66a1 
      die "Err: dir is already a decimal"
    ;;
   *) : ;;
esac


parentdir=$(dirname $realdir)
parentbase=$(basename $parentdir)

parentlast=${parentbase##*_}
parentname=${parentbase%_*}




decoutput=$(sh $decoutput_from_dirinput $realdir 2>/dev/null)

[ -f "$decoutput" ] && die "Err: is already a Decoutput $decoutput"
[ -d "$decoutput" ] && die "Err: is already a Decoutput $decoutput"


parentoutput=$(sh $decoutput_from_dirinput $parentdir 2>/dev/null)

[ -f "$parentoutput" ] || [ -d "$parentoutput" ] || die "Err: there is no  parentoutput $parentoutput"

parent_dec=$(sh $dec_from_decinput $parentoutput)

[ -n "$parent_dec" ] || die "Err: no dec"


newdec=
case "$parent_dec" in
  [1-9][1-9][a-z]*[0-9]) # 11c
    die "Err: looks like the parent has an invalid format ($parentlast)"
    ;;
  [1-9][1-9]|[1-9][1-9]*[a-z]) # 11c
    newdec=${parent_dec}0
    ;;
  *)
    die "Err: cannot not give id name"
    ;;
esac

if [ -n "$newdec" ] ; then
   echo "${yearminute}-${input_usersig}_$newdec"
else
  die "Err: no newdec"
fi
