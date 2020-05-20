
fifofile=$HOME/.fifofile

input="$@"

die () { echo $@; exit 1; }



if [ -n "$input" ] ; then
  tmpipe=$(mktemp)
  [ -f $fifofile ] && cat $fifofile > $tmpipe
  echo "$input" >> $tmpipe
  [ -f "$tmpipe" ] && head -n1000 $tmpipe > $fifofile
  
else
  if [ -t 0 ] ; then 
 [ -f "$fifofile" ] && head -n1 $fifofile
  else
  tmpipe=$(mktemp)
  [ -f $fifofile ] && cat $fifofile > $tmpipe

  while read pipe ; do
    echo $pipe >> $tmpipe
  done

  [ -f "$tmpipe" ] && head -n1000 $tmpipe > $fifofile
fi
fi
