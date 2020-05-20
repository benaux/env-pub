#!/bin/sh


USAGE='number'

method=base10tobase26

here=$(dirname $0)

mathlib=$here/../morelib/math

input=$1

die () { echo $@; exit 1; }

[ -n "$input" ] || die "usage: $USAGE"

is_numeric=$(perl -e '$ARGV[0] =~ /^\d*$/ and print 1' $input)

[ "$is_numeric" = '1' ] || die "Err: input not numeric"

ok=
for tuple in perl:pl ruby:rb node:js nodejs:js ; do
  lang=${tuple%:*}
  ext=${tuple##*:}

  interp=$(which $lang)

  if [ -n "$interp" ] ; then
    script=$mathlib/$method.$ext
    if [ -f "$script" ] ; then
      $interp "$script" "$input"
      ok=1
      exit
    else
      continue
    fi
  fi

done

[ -n "$ok" ] || die "err: could no do base26 conv for $input"
