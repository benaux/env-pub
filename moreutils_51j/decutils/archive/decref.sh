#!/bin/sh

USAGE='<reference_file.ref>'

decrefs=$HOME/.decrefs

input=$1

die () { echo $@; exit 1; }

[ -f "$decrefs" ] || die "Err: no ~/.decrefs" 

[ -n "$input" ] || die "usage: $USAGE"

[ -f "$input" ] || die "Err: input $input no file"

baseinput=$(basename $input)

os=$(uname)

dir=
case "$input" in
  *.ref)
    refname=${baseinput%.*}
    decref=_bk${refname##*_bk}
    

    case "$os" in
      Darwin)
        #dir=$(mdfind -name "$baseinput")
        dir=$(perl -F':' -lane "if(/$decref/){ \$x=\$F[1] ; \$x =~ s/^\s+|\s+\$//g;  print \$x ; } " $decrefs)

        ;;
      *)
        die "Err: os $os todo"
        ;;
    esac

    ;;
   *)
      die "Err: no reference file"
   ;;
esac

echo $dir 

