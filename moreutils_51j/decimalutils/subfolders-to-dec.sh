

# rename all subfolders from a folder to decimals

cwd=$(pwd)


die () { echo $@; exit 1; }

inputdir=$1

[ -d "$inputdir" ] || die "usage: dir"

input_base=$(basename $inputdir)
input_ext=${input_base##*_}

case "$input_ext" in
  [0-9][0-9]|[0-9][0-9][a-z]|[0-9][0-9][a-z][0-9]|[0-9][0-][a-z][a-z])
    :
    ;;
  *)
    die 'ffffffuuu'
    ;;
esac


rename_to_decimal () {
   local basedir="$1"
   local sourcedir="$2"

   target_base=$inputdir/${basedir}_$input_ext

   match= decimal= success=
   for char in {a..z} ; do
      decimal=${input_ext}${char}

      for d in "$inputdir/"* ; do
         [ -d "$d" ] || continue
         bd=$(basename $d)
         case "$bd" in
           *_$decimal)
             match=1 && break
             ;;
           *) match= ;;
         esac
      done
      [ -z "$match" ] && {
        success=1 
         break
       }
    done

   [ -n "$success" ] || die "Err: found no new name"

   newdir=$inputdir/${basedir}_$decimal

   if [ -d "$newdir" ] ; then 
      die "Err: dir $newname already exists"
   else
       mv $sourcedir $newdir
   fi 
}

for d in "$inputdir/"* ; do
  [ -d "$d" ] || continue
  bd=$(basename $d)


  case "$bd" in
    *_[0-9][0-9]*)
      echo "Warn: $bd looks like decinal. skip ... "
      continue
      ;;
    *)
      rename_to_decimal "$bd" "$d"

      ;;
  esac

done


