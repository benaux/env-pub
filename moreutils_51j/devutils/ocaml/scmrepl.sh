

scm2ml=$HOME/tools/utils/scm2ml

slime_paste=$HOME/.slime_paste

die () { echo $@; exit 1; }

[ -f "$scm2ml" ] || die "Err:scm2ml not installed";

tmp=$(mktemp)
while read expr ; do
  if [ -n "$expr" ] ; then
    sleep 0.1
    cat $slime_paste
#    ${scm2ml} "$tmp"
  else
    echo fff
  fi
done
