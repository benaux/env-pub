#!/bin/sh
# Copyright (c) 2020 ben
# Licensed under the MIT license. See License-MIT.txt in project root.

HELP="Returns the dec from a decfile or a decdir"
USAGE="<decfile> | <decdir>"

input="$1"

here=$(dirname $0)

decitem_from_dirinput=$here/decitem-from-dirinput.sh

required_input=

die () { echo "$@" 1>&2; exit 1; }
warn () { echo "$@" 1>&2; }
usage () { [ -n "$1" ] && warn "$1"; local app=$(basename $0); die "usage - $app: $USAGE"; }
help () { warn "Help: $HELP" ; usage ; }
realpath () { perl -MCwd -le 'print Cwd::realpath($ARGV[0])' $1; }
filename () { local base=$1; local sep=$2; echo ${base%${sep}*} ; }
fileext () { local base=$1; local sep=$2; ext=${base##*${sep}} ; [ "$base" = "$ext" ] || echo $ext ; }

[ -n "$input" ] || usage

[ -f "$decitem_from_dirinput" ] || die "Err: no script in $here/decitem-from-dirinput.sh"

dec_input=
while [ $# -gt 0 ]; do
   arg="$1"
   shift
   case "$arg" in
      -h|--help) help ;;
      -*) die "Err: invalid option use -h for help" ;;
      *) dec_input="$arg" ;;
  esac
done


dec_real=$(realpath $dec_input)
[ -f "$dec_real" ] || [ -d "$dec_real" ] || die "Err: path '$dec_real' invalid"

dec_dir=$(dirname $dec_real)
dec_base=$(basename $dec_real)

decfile_to_decname () {
   local realfile=$1
   local decbase=$2

   local decname=

   case "$decbase" in
      .*_*.dec.txt) 
        decleft=${decbase#*.}
        decname1=$(filename $decleft .) 
        decname=$(filename $decname1 .) 
        ;;
      .*_*.dec) 
        decleft=${decbase#*.}
        decname1=$(filename $decleft .) 
        decname=$(filename $decname1 .) 
        ;;
      *_*.dec.txt) 
        decname1=$(filename $decbase .) 
        decname=$(filename $decname1 .) 
        ;;
      *_*.dec) 
        decname=$(filename $decbase .) 
        ;;
      *) die "Err: $dec_input not a decfile" ;;
    esac

    echo "$decname"
}

dec_name=
if [ -f "$dec_real" ]; then
  dec_name=$(decfile_to_decname "$dec_real" "$dec_base") 
elif [ -d "$dec_real" ]; then
  #echo decreal $dec_real

  case "$dec_base" in
  *_[0-9][0-9]|*_[0-9][0-9]0|*_[0-9][0-9][a-z]*) 
    dec_name="$dec_base"
    ;;
  *)
      dec_item=$(sh $decitem_from_dirinput $dec_real)
      decitem_base=$(basename $dec_item)
      dec_name=$(decfile_to_decname "$dec_real" "$decitem_base") 
    ;;
   esac
else
  die "Err:  invalid input"
fi

[ -n "$dec_name" ] || die "Err: no decname $dec_name"

dec=$(fileext $dec_name _)

case "$dec" in
  [0-9][0-9]|[0-9][0-9]0|[0-9][0-9][a-z]*) 
    echo "$dec"
    ;;
  *)
    die "Err: not a valid $dec from decname $dec_name in decbase $dec_base from decreal $dec_real"
    ;;
esac



