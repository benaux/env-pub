
USAGE='<node names>'

userid='bk'

shortid="${userid:0:1}"


homebase=$HOME/base

redir=$homebase/redir

nodes=$homebase/nodes

favs=$HOME/favs

die () { echo $@; exit 1; }

[ -n "$1" ] || die "usage: $USAGE"
[ -d "$nodes" ] || die "Err: no nodes directroy  in $nodes"

mkdir -p $redir
rm -f ~/r
ln -s $redir ~/r

heximals=$homebase/heximals
mkdir -p $heximals
rm -f $redir/heximals
ln -s $heximals $redir/heximals


link_node () {
  local nodedir=$1

for d in $(find -L "$nodedir" -iname "*_[0-9][0-9x]*") ; do
  [ -d "$d" ] || continue
  echo nnnn $d 
  continue

  bd=$(basename $d)
#echo bddd $bd

  case "$bd" in
    *_${shortid}[a-z-][0-9][0-9x][0.]*) # dont link stuff like: archive_bk110, or old heximals like 11.1
      # archives etc
      echo omit $bd
      :
      ;;
    *_${shortid}[a-z-][0-9][0-9x][a-z][a-z][0-9]*) # dont link into ~/r/ stuff like: twik_bk11ab1
      rm -f $heximals/$bd
      ln -s $d $heximals/$bd
      ;;
    *)
      rm -f $heximals/$bd
      ln -s $d $heximals/$bd

      rm -f $redir/$bd
      ln -s $d $redir/$bd
      ;;
  esac
done
}

for nodename in $@; do
  for d in $nodes/* ; do
     basedir=$(basename $d)

     username=$(perl -e '$ARGV[0] =~ /\w\-(.*node)\.(\w+)\.\w/ && print "$1s/$2"' $basedir)


     if [ -n "$username" ] ; then
     echo d $d $username
     fi
     continue


     case "$basedir" in
        $nodename-datanode.*|$nodename-storenode.*|$nodename-datanode_*|$nodename-storenode_*) 
          link_node $d
        ;;
      *) 
        :
        ;;
    esac
  done
done


rm -f $redir/favs
ln -s $favs $redir/favs

for i in $favs/* ; do
  [ -d "$i" ] || continue
  bi=$(basename $i)
  rm -f $redir/$bi
  ln -s $i $redir/$bi
done
