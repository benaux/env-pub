
USAGE='<sourcedir> <releasedir>'

# structure
# ---------
# release-dir
# mandatory subdirs: release-dir/archive
# optional subdirs (get cleanup): eg. release-dir/sourcetext



src_file="$1"
rel_dir="$2"

release_archive=$rel_dir/archive

die () { echo $@ 1>&2;  exit 1; }

[ -n "$src_file" ] || die "usage: $USAGE"
[ -n "$rel_dir" ] || die "usage: $USAGE"

[ -f "$src_file" ] || die "Err: src dir not exist"
[ -d "$rel_dir" ] || die "Err: rel dir not exist"

case "$rel_dir" in 
  '.') die "Err invlid release dir";;
  *) : ;;
esac


src_base=$(basename $src_file)
src_parent=$(dirname $src_file)

rel_base=$(basename $rel_dir)
rel_parent=$(dirname $rel_dir)

today=$(date "+%Y-%m-%d")

# remove xxx.git from 
filename=${src_base%.*}
fileext=${src_base##*.}

releasefile=${filename}_${today}.$fileext

[ -f "$rel_dir/$releasefile" ] && die "Err: there is already a release file '$rel_dir/$releasefile'."

[ -f "$release_archive/$releasefile" ] && die "Err: there is already a release file '$release_archive/$releasefile'."

mkdir -p $release_archive

rm -f $rel_dir/$rel_base

echo cp $src_file $rel_dir/$rel_base
cp $src_file $rel_dir/$src_base

echo cp $src_file $rel_dir/$releasefile
cp $src_file $rel_dir/$releasefile


