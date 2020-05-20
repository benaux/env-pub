
die () { echo $@; exit 2; }

techcards=$HOME/notes/techcards
stamp_minute_base=~/tools/moreutils/stamps/stamp-minute-base26.sh
fifo=~/tools/utils/fifo.sh

[ -e "$techcards" ] || die "Err: no dir/link $techcards"
[ -f "$stamp_minute_base" ] || die "Err: no script $stamp_minute_base"
[ -f "$fifo" ] || die "Err: no script $fifo"

title="$@"

if [ -z "$title" ] ; then
  echo "Please enter tile"
  read title
fi

[ -z "$title" ] && die "Err:no title" 

userstamp=$(sh $stamp_minute_base -u)

[ "$?" = "0" ] || die "Err: no stamp"
[ -n "$userstamp"  ] || die "Err: no stamp"


filetitle=$(perl -e '$_ = $ARGV[0]; s/^\s+|\s+$//g;s/\W+/_/g; print' "$title")
[ -n "$filetitle"  ] || die "Err: no filetitle"

today=$(date "+%F")

path=$techcards/${filetitle}_${userstamp}.txt

[ -f "$path" ] && die "Err: file exists in $path"

{
  echo $title
  echo ""
  echo "date: $today"
  echo "uid: $userstamp"
  echo ""
} > $path

sh $fifo $path

echo "Ok: written to $path. "
echo "[A]dd some text."
echo "open in [V]im"
echo "Do [N]othing"

read answer

case "$answer" in
  a)
    read text
    echo "$text" >> $path
    ;;
  v)
    ~/tools/utils/v $path
    ;;
  *)
    :
    ;;
esac

echo '------' $path '-----'
cat $path
