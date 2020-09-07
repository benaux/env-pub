#!/bin/sh
# Copyright (c) 2020 ben
# Licensed under the MIT license. See License-MIT.txt in project root.

HELP="Resolves to a path for a decinput. If input is a decdir, path to dir returned if valid. If input is a valid decfile, the corresponding path to dir is returned"
USAGE="<decfile> | <decdir>"

input="$1"

decinput=

die () { echo "$@" 1>&2; exit 1; }
warn () { echo "$@" 1>&2; }
usage () { [ -n "$1" ] && warn "$1"; local app=$(basename $0); die "usage - $app: $USAGE"; }
help () { warn "Help: $HELP" ; usage ; }
realpath () { perl -MCwd -le 'print Cwd::realpath($ARGV[0])' $1; }
filename () { local base=$1; local sep=$2; echo ${base%${sep}*} ; }
fileext () { local base=$1; local sep=$2; ext=${base##*${sep}} ; [ "$base" = "$ext" ] || echo $ext ; }

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

[ -d "$decinput" ] || [ -f "$decinput" ] || die "Err: $decinput is invalid input (no file/folder)";

decinput_realpath=$(realpath $decinput)
decinput_basename=$(basename $decinput_realpath)


tryfail_decpart () {
   local decname="$1"

   case "$decname" in
      *_*-*_|*_*.*_*|*_*_*|*_*)
         decpart=$(fileext $decname '_')

         case "$decpart" in
            [0-9][0-9]|[0-9][0-9]0*|[0-9][0-9][a-z]*) : ;;
            *) die "Err: input ($decpart) has not a dec format" ;;
         esac
      ;;
      *) die "Err: input '$decname' has not a dec format" ;;
  esac
}

if [ -d "$decinput" ] ; then
   tryfail_decpart $decinput_basename 

   printf $decinput_realpath

elif [ -f "$decinput" ] ; then

   dec_name=
   case "$decinput_basename" in
      *.dec|*.dec.txt)
         case "$decinput_basename" in
            .*) nodot=${decinput_basename#*.}
               dec_name=$(filename $nodot '.') ;;
            *)
               dec_name=$(filename $decinput_basename '.')
             ;;
         esac
         ;;
       *) die "Err: '$decinput' is not a decfile" ;;
   esac

   tryfail_decpart $dec_name

   dec_dir=$(dirname "$decinput_realpath")

   match_dir=
   for d in "$dec_dir"/* ; do
      [ -d "$d" ] || continue
      bd=$(basename $d)

      case "$dec_name" in
         ${bd}_*)
            if [ -n "$match_dir" ] ; then
               die "Err: could not detect a dir (possible doublettes)"
            else
               match_dir=$d
            fi
            ;;
         *) : ;;
      esac
   done

   if [ -n "$match_dir" ] ; then
      #decinput_parent=$(dirname $decinput_realpath)
      #decdir=$decinput_parent/$match_dir
      if [ -d "$match_dir" ] ; then
        printf "$match_dir"
      else
        die "Err: input invalid - no dir for decfile"
      fi
  else
    die "Err: could not detect a dir"
  fi
else
  die "Err: invalid input "
fi




