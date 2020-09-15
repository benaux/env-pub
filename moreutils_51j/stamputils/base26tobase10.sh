USAGE='string'

method=base26tobase10

here=$(dirname $0)

tools=$HOME/tools
mathlib=$tools/morelibs/mathlib

input=$1

die () { echo $@; exit 1; }

[ -n "$input" ] || die "usage: $USAGE"
[ -d "$mathlib" ] || die "Err: no datelib dir in $mathlib"

ok=
for tuple in ruby:rb node:js nodejs:js perl:pl; do
  lang=${tuple%:*}
  ext=${tuple##*:}

  interp=$(which $lang)

  if [ -n "$interp" ] ; then
    script=$mathlib/$method.$ext
   #echo ssss $script
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
