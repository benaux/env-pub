#!/bin/sh
# Copyright (c) 2020 ben
# Licensed under the MIT license. See License-MIT.txt in project root.

HELP=""
USAGE="--user <user-sig> [--dir <note-dir>] Title "

dir_input_default='.'

title_input= user_sig= dir_input=

stamp_minute_crock=$HOME/tools/moreutils/stamputils/crock-minute.sh

## Disable for dash
set -o errexit -o errtrace # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

cwd=$(pwd)
cwd_base=$(basename $cwd)
die () { echo "$@" 1>&2; exit 1; }
warn () { echo "$@" 1>&2; }
usage () { [ -n "$1" ] && warn "$1"; local app=$(basename $0); die "usage - $app: $USAGE"; }
help () { warn "Help: $HELP" ; usage ; }
cmdcheck () { for c in $@ ; do 
  [ -f "$c" ] || command -v $c >/dev/null 2>&1 || die "Err: no cmd '$c' installed"  ; 
done ; }
realpath () { perl -MCwd -le 'print Cwd::realpath($ARGV[0])' $1; }
filename () { local base=$1; local sep=$2; echo ${base%${sep}*} ; }
fileext () { local base=$1; local sep=$2; ext=${base##*${sep}} ; [ "$base" = "$ext" ] || echo $ext ; }
cleanup () { echo ok ; }

#[ $# -eq $argc ] || usage ""

cmdcheck $stamp_minute_crock

while [ $# -gt 0 ]; do
   arg="$1"
   case "$arg" in
      -h|--help) help ;;
      -d|--dir) shift ; dir_input=$1 ;;
      -u|--user) shift ; user_sig="$1" ;;
      -*) die "Err: invalid option use -h for help" ;;
      *) break ;;
  esac
   shift
done

title_input="$@"

[ -n "$user_sig" ] || die "Err: no user_sig invalid $user_sig"
[ -n "$dir_input" ] || dir_input=$dir_input_default

[ -d "$dir_input" ] || die "Err: no invalid dir input"

minute_stamp=$(sh $stamp_minute_crock)
[ "$?" = "0" ] || die "Err: no stamp"
[ -n "$minute_stamp"  ] || die "Err: no stamp"

if [ -z "$title_input" ] ; then
  echo "Please enter tile"
  read title_input
fi

[ -z "$title_input" ] && die "Err:no title" 

filetitle=$(perl -e '$_ = $ARGV[0]; s/^\s+|\s+$//g;s/\W+/-/g; print(lc $_)' "$title_input")
[ -n "$filetitle"  ] || die "Err: no filetitle"

today=$(date "+%F")

userstamp=${minute_stamp}-${user_sig}
path=$dir_input/${filetitle}_${userstamp}.txt

[ -f "$path" ] && die "Err: file exists in $path"

{
  echo $title_input
  echo ""
  echo "    date: $today"
  echo "    id: $userstamp"
  echo ""
} > $path


os=$(uname)
case "$os" in
  Darwin)
    echo $path | pbcopy
    ;;
  *)
    :
    ;;
esac

echo "Ok: path $path copied. "

