#!/bin/sh
# Copyright (c) 2020 ben
# Licensed under the MIT license. See License-MIT.txt in project root.

HELP=""
USAGE="<input-dir><input-usersig>"

argc=2

input_dir=
input_usersig=

declib=$HOME/tools/morelibs/declib
yeardec_from_dirinput=$declib/yeardec-from-dirinput.sh
decoutput_from_dirinput=$declib/decoutput-from-dirinput.sh

## Disable for dash
#set -o errexit -o errtrace # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

cwd=$(pwd)
cwd_base=$(basename $cwd)
die () { echo "$@" 1>&2; exit 1; }
warn () { echo "$@" 1>&2; }
usage () { [ -n "$1" ] && warn "$1"; local app=$(basename $0); die "usage - $app: $USAGE"; }
help () { warn "Help: $HELP" ; usage ; }
cmdcheck () { for c in $@ ; do 
  command -v $c >/dev/null 2>&1 || die "Err: no cmd '$c' installed"  ; 
done ; }
realpath () { perl -MCwd -le 'print Cwd::realpath($ARGV[0])' $1; }
filename () { local base=$1; local sep=$2; echo ${base%${sep}*} ; }
fileext () { local base=$1; local sep=$2; ext=${base##*${sep}} ; [ "$base" = "$ext" ] || echo $ext ; }
cleanup () { : ; }

[ $# -eq $argc ] || usage ""

[ -f "$yeardec_from_dirinput" ] || die "Err: $HOME/tools/morelibs/zerodec-from-dirinput.sh"
[ -f "$decoutput_from_dirinput" ] || die "Err: no=$declib/decoutput-from-dirinput.sh"

while [ $# -gt 0 ]; do
   arg="$1"
   shift
   case "$arg" in
      -h|--help) help ;;

      -*) die "Err: invalid option use -h for help" ;;
      *) 
        input_dir="$arg" 
        input_usersig="$1" 
        shift
        ;;
  esac
done

dir_path=$(realpath $input_dir)
[ -d "$dir_path" ] || die "Err: dir path $dir_path is invalid"

dir_decoutput=$(sh $decoutput_from_dirinput $dir_path 2>> /dev/null)
[ -z "$dir_decoutput" ] || die "Err: already a decdir ($dir_decoutput)"

yeardec=$(sh $yeardec_from_dirinput $input_dir $input_usersig)

yeardec_name=${input_dir}_$yeardec

yeardec_filename=.$yeardec_name.dec

if [ -f "$yeardec_filename" ] ; then
  die "Err: file $yeardec_filename already exists"
else
  touch $yeardec_filename
fi

#trap "cleanup" EXIT
