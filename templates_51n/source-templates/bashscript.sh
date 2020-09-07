#!/bin/sh
# Copyright (c) 2020 ben
# Licensed under the MIT license, according to License-MIT.txt in project root.

### A Template for Bash Scripts 
###
### Usage: --option=<required> <argument> [ -f | -g ] ([optional] | or <repeating>...) 
###
### Options:
###   --option     Test option
###   <argument>   Input file to read.
###   [optional]   Simple optional arg
###   -h        Show this message.


argc=1

file_input=

## Disable for dash
set -o errexit -o errtrace # abort on nonzero exitstatus
#set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

cwd=$(pwd)
cwd_base=$(basename $cwd)
die () { echo "$@" 1>&2; exit 1; }
warn () { echo "$@" 1>&2; }
usage () { 
  [ -n "$1" ] && warn "$1"; 
  u="$(/usr/bin/env perl -ne 'print if (s/^###\s*Usage:\s*?//)' $0)"; 
  local app=$(basename $0); die "usage - $app: $u"; 
}
help () {  /usr/bin/env perl -ne 'print STDERR if ( s/^### ?// )' $0; exit 1; }
cmdcheck () { for c in $@ ; do 
  command -v $c >/dev/null 2>&1 || die "Err: no cmd '$c' installed"  ; 
done ; }
argcheck () { for a in $@ ; do n=${a%%:*}; v=${a##*:};  [ -n "$v" ] || usage "<$n> not set"  ; done ; }
scriptcheck () { for c in $@ ; do [ -f "$c" ] || die "Err: no cmd '$c' installed"  ; done ; }
realpath () { perl -MCwd -le 'print Cwd::realpath($ARGV[0])' $1; }
filename () { local base=$1; local sep=$2; echo ${base%${sep}*} ; }
fileext () { local base=$1; local sep=$2; ext=${base##*${sep}} ; [ "$base" = "$ext" ] || echo $ext ; }
cleanup () { echo ok ; }

[ $# -eq $argc ] || usage ""

while [ $# -gt 0 ]; do
   arg="$1"
   shift
   case "$arg" in
      -h|--help) help ;;
      -*) die "Err: invalid option use -h for help" ;;
      *) file_input="$arg" ;;
  esac
done

file_path=$(realpath $file_input)
[ -f "$file_path" ] || die "Err: file path $file_path is invalid"


trap "cleanup" EXIT
