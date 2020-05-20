#!/bin/sh

HELP='Resolves links from the Notebooks App in the form of "notebooks://show/sub-notebook_1x3x/dev-refs"'
USAGE='<link>'

link="$1"

notebook_root=$HOME/appdata/notebooks


die () { echo $@; exit 1; }

[ -n "$link" ] || die "usage: link"

[ -d "$notebook_root" ] || die "Err: sorry no notebook link in ~/favorites"

dir=$(perl -e '$_=$ARGV[0]; s/\%20/ /g ; /notebooks\:\/\/show\/(.*)$/ && print "$1"' $link)

[ -n "$dir" ] || die "Err: no dir in link"

echo "$notebook_root/$dir"
#cd "$notebook_root/$dir"


