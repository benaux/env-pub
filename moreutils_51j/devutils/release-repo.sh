
USAGE='<sourcedir> <releasedir>'

# structure
# ---------
# release-dir
# mandatory subdirs: release-dir/archive
# optional subdirs (get cleanup): eg. release-dir/sourcetext



src_dir="$1"
rel_dir="$2"

release_archive=$rel_dir/archive

die () { echo $@ 1>&2;  exit 1; }

[ -n "$src_dir" ] || die "usage: $USAGE"
[ -n "$rel_dir" ] || die "usage: $USAGE"

[ -d "$src_dir" ] || die "Err: src dir not exist"
[ -d "$rel_dir" ] || die "Err: rel dir not exist"


case "$src_dir" in 
  '.') src_dir=$(pwd) ;;
  *) : ;;
esac

case "$rel_dir" in 
  '.') die "Err invlid release dir";;
  *) : ;;
esac


src_base=$(basename $src_dir)
src_parent=$(dirname $src_dir)

rel_base=$(basename $rel_dir)
rel_parent=$(dirname $rel_dir)

today=$(date "+%Y-%m-%d")

# remove xxx.git from dir
projectdir=${src_base%.*}

source_releasedir=${projectdir}_src${today}
[ -d "$rel_parent/$source_releasedir" ] && die "Err: there is already a release folder '$rel_parent/$source_releasedir'."
[ -d "$rel_dir/$source_releasedir" ] && die "Err: there is already a release folder '$rel_dir/$source_releasedir'."
[ -d "$release_archive/$source_releasedir" ] && die "Err: there is already a release folder '$release_archive/$source_releasedir'."

tarfile=${source_releasedir}.tar.gz
[ -f "$rel_parent/$tarfile" ] && die "Err: there is already a release file '$rel_parent/$tarfile'."
[ -f "$release_archive/$tarfile" ] && die "Err: there is already a release file '$release_archive/$tarfile'."
[ -f "$rel_dir/$tarfile" ] &&  die "Err: there is already a release file '$rel_dir/$tarfile'."

[ -f "Makefile" ] && {
   make clean
   make distclean
}

mkdir -p $release_archive


cd "$src_parent"

echo cp -r $src_dir  $source_releasedir
cp -r $src_dir  $source_releasedir

echo tar cfz $tarfile ${source_releasedir}
tar cfz $tarfile ${source_releasedir}

echo mv $tarfile $rel_dir
mv $tarfile $rel_dir/

source_latestdir=${projectdir}_latest
tarfile_latest=$source_latestdir.tar.gz

echo cp -r $src_dir  $source_latestdir
cp -r $src_dir  $source_latestdir

echo tar cfz $tarfile_latest ${source_latestdir}
tar cfz $tarfile_latest ${source_latestdir}

echo rm -f $rel_dir/$tarfile_latest
rm -f $rel_dir/$tarfile_latest

echo mv $tarfile_latest $rel_dir
mv $tarfile_latest $rel_dir/

echo rm -rf "$source_releasedir"
rm -rf "$source_releasedir"



echo "The end: $releasefile"

# for i in "$rel_dir"/*; do
#   bi=$(basename $i)
#   if [ -d "$i" ] ; then
#     case "$bi" in 
#       archive) : ;;
#       *) 
#         echo "Warn: rm -rf $i ok? [yes]|n"
#         read answ
#         [ "$answ" = 'n' ] || rm -rf "$i"
#         ;;
#     esac
#   elif [ -f "$i" ] ; then
#     if [ -f "$release_archive/$bi" ] ; then
#       die "Err: $release_archive already exists"
#     else
#       case "$bi" in 
#         *_latest*.*)
#           rm -f "$i"
#           ;;
#         *)
#          mv "$i" $release_archive/
#          ;;
#      esac
# 
#     fi
#   else
#     :
#   fi
# done

