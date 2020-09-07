
declink="$1"

basedec=$(basename $declink)


redir=$HOME/base/redir

die () { echo $@; exit 1; }

rightext=${basedec#*_}
id_decimal=${rightext%%.*}


[ -d "$redir" ] || die "Err : no redir in $redir" 

matched=
for f in $redir/* ; do
  case "$f" in
    *$id_decimal*)
      if [ -n "$matched" ] ; then
        die "Err: multiple declinks"
      else
        matched=$f
      fi
      ;;
    *)
      :
      ;;
  esac
done

ls $matched/
