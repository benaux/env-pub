#!/bin/sh


ext=$1
dir=$2

[ -n "$ext" ] || { echo "usage:<ext> <dir>"; exit 1; }
[ -n "$dir" ] || { echo "usage:<ext> <dir>"; exit 1; }
[ -d "$dir" ] || { echo "Err: invalid dir"; exit 1; }


stamp=$(date "+%F%M%S")
local_trash="local-trash/$stamp"
mkdir -p $local_trash


case "$ext" in
  [a-z]*)
    :
    ;;
  *)
    echo "Err: not an ext"
    exit 1
    ;;
esac

del_file () {
  local f="$1"
  local bf="$2"

  bfext="${bf##*.}"

  case "$bfext" in
    $ext)
      epoch=$(date +%s)
      fname="$bf.$epoch"
      echo trash $f to $local_trash/$fname, sleep for 1s
      sleep 1
      mv "$f" "$local_trash"/"$fname"
      ;;
    *)
      :
      ;;
  esac
}

handle_dir () {
  local d=$1

for i in "$d"/* ; do
  bi=$(basename "$i")
  if [ -f "$i" ] ; then
     del_file "$i" "$bi"
  elif [ -d "$i" ] ; then
    case "$bi" in
      local-trash) : ;;
      *)
         handle_dir "$i"
       ;;
   esac
  else
    echo "Warn: omit $i"
  fi
done
}

handle_dir "$dir"

echo "trashed to local trash: $local_trash"
