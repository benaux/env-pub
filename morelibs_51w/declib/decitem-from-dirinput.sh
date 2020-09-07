#!/bin/sh
# Copyright (c) 2020 ben
# Licensed under the MIT license. See License-MIT.txt in project root.

HELP="Return the (i)dec part of decfile for a dir"

USAGE="<dir>"

input="$1"


die () { echo "$@" 1>&2; exit 1; }
warn () { echo "$@" 1>&2; }
usage () { [ -n "$1" ] && warn "$1"; local app=$(basename $0); die "usage - $app: $USAGE"; }
help () { warn "Help: $HELP" ; usage ; }
realpath () { perl -MCwd -le 'print Cwd::realpath($ARGV[0])' $1; }
filename () { local base=$1; local sep=$2; echo ${base%${sep}*} ; }
fileext () { local base=$1; local sep=$2; ext=${base##*${sep}} ; [ "$base" = "$ext" ] || echo $ext ; }


[ -n "$input" ] || usage

input_dir=
while [ $# -gt 0 ]; do
   arg="$1" ; shift; 
   case "$arg" in
      -h|--help) help ;;
      -u) user_sig="$1" ; shift ;;
      --user=*)  user_sig=$(fileext "$arg" "=") ;;
      -*) die "Err: invalid option '$arg'. Use -h" ;;
      *) input_dir="$arg" ;;
  esac
done

[ -d "$input_dir" ] || "Err: dir $input_dir not a valid directory" 

real_input=$(realpath "$input_dir")
dir_base=$(basename "$real_input")

dir_name=$(filename "$dir_base" '.')

# for project_20202001akl-bt_82al
dec_from_decdir () {
   local decdir="$1"

  case "$decdir" in
    *_*)
      dec_ext=$(fileext "$decdir" '_')
      case "$dec_ext" in
        [0-9][0-9]|[0-9][0-9][a-z]*)
          echo $dec_ext
          ;;
        *) : ;;
      esac
      ;;
    *) : ;;
  esac
}

dec_one=$(dec_from_decdir $dir_name)

[ "$dec_one" ] && { 
   echo  $real_input
   exit
}
   

dir_parent=$(dirname "$real_input")


decfile_match=
for df in $dir_parent/.*.dec $dir_parent/*.dec $dir_parent/.*.dec.txt $dir_parent/*.dec.txt ; do
  [ -f "$df" ] || continue
  bdf=$(basename $df)

  case "$bdf" in
    $dir_base*|.$dir_base*)
      if [ -n "$decfile_match" ] ; then
        die "Err: more than one match for dir '$real_input'"
      else
         decfile_match=$df
      fi
      ;;
    *) : ;;
  esac
done


if [ -n "$decfile_match" ] ; then
   decname=$(basename $decfile_match)
   decfile=$(filename "$decname" '.')
   decimal=$(dec_from_decdir $decfile)

   if [ -n "$decimal" ]; then
     echo "$decfile_match"
   else
     die "Err: no decimal found"
   fi
else
   die "Err: no *.decfile match for dir '$input_dir'"
fi
