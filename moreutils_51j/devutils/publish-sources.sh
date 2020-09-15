
USAGE='<dir>'

die () {
  echo $@ 1>&2
  exit 1
}

dir=
if [ -n "$1" ] ; then
   dir="$1"
else
  die "usage: $USAGE"
fi

case "$dir" in 
  '.') dir=$(pwd) ;;
  *) : ;;
esac


dir_here=$(basename $dir)
dir_dir=$(dirname $dir)
source_dir="$dir_dir"/sources


cd $dir_dir
rm -rf "$source_dir"
cp -r "$dir" "$source_dir"

cd "$source_dir"

make distclean
make doc >> /dev/null


for f in *; do
  [ -f "$f" ] || continue
  bf=$(basename $f)
  case "$bf" in
    *.zip|*.tar.gz) : ;;
    *.txt|*.md|*.html)
      cp $f $source_releasedir/$bf
      ;;
    *)
      cp $f $source_releasedir/$bf.txt
    ;;
   esac
done



