

die () {
  echo $@ 1>&2
  exit 1
}

today=$(date +"%F")

cwd=$(pwd)

cwd_here=$(basename $cwd)

projectdir=${cwd_here%.*}
[ -d "$projectdir" ] && die "Err: there is already a projectdir folder '$projectdir'."

source_releasedir=${projectdir}_sources_${today}
[ -d "$source_releasedir" ] && die "Err: there is already a release folder '$source_releasedir'."

releasefile=${source_releasedir}.tar.gz
[ -f "$releasefile" ] && die "Err: there is already a release file $releasefile"

mkdir -p $source_releasedir
make distclean
cp * $source_releasedir/

tar cfz $releasefile ${source_releasedir}

rm -rf "$source_releasedir"

mkdir -p $projectdir

make doc

for f in *; do
  [ -f "$f" ] || continue
  bf=$(basename $f)
  case "$bf" in
    *.zip|*.tar.gz) : ;;
    *.txt|*.md|*.html)
      cp $f $projectdir/$bf
      ;;
    *)
      cp $f $projectdir/$bf.txt
    ;;
   esac
done



