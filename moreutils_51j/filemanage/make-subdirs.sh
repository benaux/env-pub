USAGE='<delim> [dir]'

delim="$1"
dir="$2"

die () { echo "$@" 1>&2; exit 1;  }

[ -n "$delim" ] || die "usage: $USAGE"

[ -n "$dir" ] || dir=$(pwd)
[ -d "$dir" ] || die "Err: dir $dir is invalid"


for f in "$dir"/* ; do
   [ -f "$f" ] || continue
   bf=$(basename "$f")
   left="${bf%${delim}*}"
   right="${bf##*${delim}}"
   [ "$left" = "$right" ] || {
      mkdir -p "$dir/$left"
   mv "$f" "$dir/$left/$right"
   }
done
