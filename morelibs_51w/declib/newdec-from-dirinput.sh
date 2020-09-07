#!/bin/sh
# Copyright (c) 2020 ben
# Licensed under the MIT license. See License-MIT.txt in project root.

HELP="Return deced folder"
USAGE="--option=<required> <argument> [ -f | -g ] ([optional] | or <repeating>...) "

input="$1"

required_input=

heredir=$(dirname $0)
decitem_from_dirinput=$heredir/decitem-from-dirinput.sh
dec_from_decinput=$heredir/dec-from-decinput.sh

die () { echo "$@" 1>&2; exit 1; }
warn () { echo "$@" 1>&2; }
usage () { [ -n "$1" ] && warn "$1"; local app=$(basename $0); die "usage - $app: $USAGE"; }
help () { warn "Help: $HELP" ; usage ; }
realpath () { perl -MCwd -le 'print Cwd::realpath($ARGV[0])' $1; }
filename () { local base=$1; local sep=$2; echo ${base%${sep}*} ; }
fileext () { local base=$1; local sep=$2; ext=${base##*${sep}} ; [ "$base" = "$ext" ] || echo $    ext ; }

[ -n "$input" ] || usage

[ -f "$decitem_from_dirinput" ] || die "Err: $heredir/decitem-from-dirinput.sh not here"
[ -f "$dec_from_decinput" ] || die "Err: $heredir/dec-from-decinput.sh not here"

while [ $# -gt 0 ]; do
   arg="$1"
   shift
   case "$arg" in
      -h|--help) help ;;
      -*) die "Err: invalid option use -h for help" ;;
      *) required_input="$arg" ;;
  esac
done

realdir=$(realpath $input)
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



getid_num () {
  local parent_dec=$1
  local parent_dir=$2

   enddec=
   for i in $(seq 10); do
      newdec=$parent_dec$i
      for d in $parent_dir/* ; do
         [ -d "$d" ] || continue
         bd=$(basename $d)
         dec=${bd##*_}
         case "$dec" in
            [1-9][1-9][a-z][0-9]*)
               if [   "$dec" = "$newdec" ] ; then
                  enddec=
                  break
               else
                  enddec=$newdec
               fi
            ;;
            [1-9][1-9]*) die "Err: this folder looks wrong " $d ;;
            *)
               enddec=$newdec
            ;;
        esac
      done
      [ -n "$enddec" ] && break
 done

 echo $enddec
}


getid_alphanum () {
  local parent_dec=$1
  local parent_dir=$2

   enddec=
   for i in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
      newdec=$parent_dec$i
      for d in $parent_dir/* ; do
         [ -d "$d" ] || continue
         bd=$(basename $d)
         dec=${bd##*_}
         case "$dec" in
            [1-9][1-9][a-z][0-9]*)
              die "Err: this folder looks wrong"
              ;;
            [1-9][1-9][a-z]*)
               if [   "$dec" = "$newdec" ] ; then
                  enddec=
                  break
               else
                  enddec=$newdec
               fi
            ;;
            [1-9][1-9]*) die "Err: this folder looks wrong " $d ;;
            *)
               enddec=$newdec
            ;;
        esac
      done
      [ -n "$enddec" ] && break
 done

 echo $enddec
}

decitem=$(sh $decitem_from_dirinput $realdir 2>/dev/null)

[ -f "$decitem" ] && die "Err: is already a decitem $decitem"
[ -d "$decitem" ] && die "Err: is already a decitem $decitem"


parentoutput=$(sh $decitem_from_dirinput $parentdir 2>/dev/null)

[ -f "$parentoutput" ] || [ -d "$parentoutput" ] || die "Err: there is no  parentoutput $parentoutput"

parent_dec=$(sh $dec_from_decinput $parentoutput)

[ -n "$parent_dec" ] || die "Err: no dec"


newdec=
case "$parent_dec" in
  [1-9][1-9][a-z]*[0-9]) # 11c
    die "Err: looks like the parent has an invalid format ($parentlast)"
    ;;
  [1-9][1-9]*[a-z]) # 11c
    #newdec=$(getid_num $parent_dec)
    newdec=$(getid_alphanum $parent_dec $parentdir)

    #echo yyyy $newdec xx  ${thisbase}_$parent_dec
    ;;
  [1-9][1-9]) # 11c
    # echo aaaaa
    newdec=$(getid_alphanum $parent_dec $parentdir)
    ;;
  *)
    die "Err: cannot not give id name"
    ;;
esac

if [ -n "$newdec" ] ; then
   echo "$newdec"
   #echo "${thisbase}_$newdec"
else
  die "Err: no newdec"
fi
