
HELP='turn a directory with different (source) files into a bunch of .txt files'

USAGE='<dir>'


dir="$1"

die () { echo "$@" 1>&2; exit 1; }

[ -n "$dir" ] || die "usage: $USAGE"
[ -d "$dir" ] || die "Err invalid dir"


parent_dir=$(dirname $dir)
srctxt=sourcetext



handle_file () {
   local file="$1"

   bfile=$(basename "$file")
   ext=${bfile##*.}


   case "$ext" in
      md|html|zip|gz|jar|exe|bin|txt) : ;;
      php|pl|py|js|c|cpp|scm|ss|hx|zig|sh|lisp|lsp|java|json|rc|go)
         #textify "$file" "$bfile" 
         mv $file $file.txt
      ;;
      *)
         echo "Turn $file into text? [yes]|n"
         read answ
         case "$answ" in
            n*) : ;;
            *) 
              mv $file $file.txt
               #textify "$file" "$bfile"
            ;;
         esac
      ;;
   esac
 }



handle_dir () {
  local dir="$1"

  for i in "$dir"/* ; do
    if [ -f "$i" ] ; then
      handle_file "$i"
    elif [ -d "$i" ] ; then
      handle_dir "$i"
    else 
      :
    fi
  done
}

rm -rf $srctxt

mkdir -p $srctxt

for i in "$dir"/* ; do
  bi=$(basename $i)
  case "$bi" in 
    $srctxt) : ;;
    *)
      cp $i $srctxt/
      ;;
  esac
done

handle_dir "$srctxt"


