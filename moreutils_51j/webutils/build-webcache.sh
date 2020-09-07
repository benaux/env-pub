#!/bin/sh
# Copyright (c) 2020 ben
# Licensed under the MIT license. See License-MIT.txt in project root.

HELP=""
USAGE="<sig> <url>"

titledir_max_length=30 # max length of directroy name

wget_cmd='/usr/bin/env wget -r -l 1 --no-directories -A png,jpg,jpeg,gif,css,html,js ‐‐page-requisites ‐‐span-hosts ‐‐convert-links ‐‐adjust-extension -e robots=off'

#wget -E -H -k -K -nd -N -p -P

day_sec_base26=$HOME/tools/moreutils/stamputils/day-sec-base26.sh
sanitize_string=$HOME/tools/morelibs/stringlib/sanitize-string.pl
get_html_title=$HOME/tools/morelibs/stringlib/html-title.pl

arg="$@"

url_input= sig_input=


## Disable for dash
#set -o errexit -o errtrace # abort on nonzero exitstatus
#set -o nounset   # abort on unbound variable
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
scriptcheck () { for c in $@ ; do [ -f "$c" ] || die "Err: no cmd '$c' installed"  ; done ; }
argcheck () { for a in $@ ; do n=${a%%:*}; v=${a##*:};  [ -n "$v" ] || usage "<$n> not set"  ; done ; }
realpath () { perl -MCwd -le 'print Cwd::realpath($ARGV[0])' $1; }
filename () { local base=$1; local sep=$2; echo ${base%${sep}*} ; }
fileext () { local base=$1; local sep=$2; ext=${base##*${sep}} ; [ "$base" = "$ext" ] || echo $ext ; }
cleanup () { echo ok ; }

[ $# -gt 0 ] || usage ""

while [ $# -gt 0 ] ; do
  arg=$1
  shift
  case "$arg" in
     -h|--help) help ;;
     -*) die "Err: invalid option use -h for help" ;;
     *) 
      sig_input="$arg"
      url_input="$1"
      shift
      ;;
  esac
done


argcheck "sig_input:$sig_input" "url_input:$url_input"

case "$url_input" in
  http*) : ;;
  *) die "Err: doesnt look like an url";;
esac

cmdcheck wget

scriptcheck $day_sec_base26 $sanitize_string $get_html_title

cli_browser=$(command -v elinks)
[ -n "$cli_browser" ] || cli_browser=$(command -v lynx)
[ -n "$cli_browser" ] || die "Err: no valid cli browser like lynx or elinks"


htmltmp=$(mktemp)

/usr/bin/env wget -O "$htmltmp"  "${url_input}"  >> /dev/null 2>&1


html_title=
if [ -f "$htmltmp" ] ;then
   html_title="$(/usr/bin/env perl $get_html_title $htmltmp )"
 else
   die "Err: no temp html file downloaded"
fi

file_title=
if [ -n "$html_title" ] ;then
  sane_title=$(/usr/bin/env perl $sanitize_string "$html_title")
  [ -n "$sane_title" ] || die "Err: could not sanitize htmltitle"
   file_title="${sane_title:0:$titledir_max_length}"
else
   die "Err: no html title could be fetched"
fi

stamp=$(sh $day_sec_base26)

stamp_dir=${stamp}-${sig_input}
webcache_dir=webcache/${file_title}_${stamp_dir}
webcache_dir_path=$cwd/$webcache_dir

webcache_meta=${webcache_dir}/meta.txt
webcache_meta_path=$cwd/$webcache_meta


for i in $webcache_dir_path $webcache_text_path $webcache_meta_path; do
  [ -f "$i" ] && die "Err: $f already exists"
  [ -d "$i" ] && die "Err: $f already exists"
done

mkdir -p $webcache_dir_path/html

cp $htmltmp $webcache_dir_path/original.html

/usr/bin/env wget ${wget_cmd} -P $webcache_dir_path/html  "${url_input}"  >> /dev/null 2>&1

{
  echo "title: $html_title"
  echo "url: $url_input"
  echo "id: $stamp_dir"
  echo "html: html/index.html" 
  echo ""
  echo ---
  echo ""
} > $webcache_meta_path

texttmp=$(mktemp)
${cli_browser} -dump $htmltmp  > $texttmp

cat $texttmp >> $webcache_meta_path

userstamp=$(sh $day_sec_base26)

if [ "$userstamp" = "$stamp" ] ; then
  sleep 1
   userstamp=$(sh $day_sec_base26)
fi

userstampsig=${userstamp}-${sig_input}

webcache_text=webcache_${file_title}_${userstampsig}.txt
webcache_text_path=$cwd/$webcache_text

{
  echo "title: $html_title"
  echo "url: $url_input"
  echo "id: $userstampsig"
  echo "ref: $stamp_dir"
  echo ""
  echo ---
  echo ""
} > $webcache_text_path

cat $texttmp >> $webcache_text_path

echo "webcache dir is copied: $webcache_dir_path in case for download with chrome"

printf $webcache_dir_path | pbcopy

#trap "cleanup" EXIT
