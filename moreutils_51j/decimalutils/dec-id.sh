#!/bin/sh

USAGE='input dir'

input=$1

cwd=$(pwd)

realpath () {
   perl -MCwd -le 'print Cwd::realpath($ARGV[0])' $1
}

die () { echo $@ 1>&2; exit 1; }

[ -n "$input" ] || die "usage: $USAGE"

[ -d "$input" ] || die "Err: no a valid dir"


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

parent_dec=${parentlast%.*}
parent_float=${parentlast##*.}


getid_num () {
   enddec=
   for i in $(seq 10); do
      newdec=$parent_dec$i
      for d in $parentdir/* ; do
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

 echo ${thisbase}_$enddec
}

getid_alphanum () {
   enddec=
   for i in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
      newdec=$parent_dec$i
      for d in $parentdir/* ; do
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

 echo ${thisbase}_$enddec
}




case "$parentlast" in
  [1-9][1-9][a-z]*[0-9]*) # 11c
    die "Err: looks like the parent has an invalid format"
    ;;
  [1-9][1-9][a-z]*) # 11c
    getid_num $parent_dec
    ;;
  [1-9][1-9]) # 11c
    getid_alphanum $parent_dec
    ;;
  *)
    die "Err: cannot not give id name"
    ;;
esac
