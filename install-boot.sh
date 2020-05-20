
arg="$1"

[ -n "$arg" ] || { echo "usage: [-u user] usr dirs" ;  exit 1; }

usrname=

case "$arg" in
  -u|--user)
    shift
    usrname="$1"
    shift
    firstdir="$1"
    ;;
  *)
   usrname=$(whoami)
    firstdir=$arg
    ;;
esac

  

roots=$(dirname $firstdir)
rootsbase=$(basename $roots)

case "$rootsbase" in 
  userdir_|*dir_*) : ;;
  *) 
    echo "Err: not a valid path, no root: $roots"
    exit 1
    ;;
esac


homebase=$HOME/base

redir=$homebase/redir
mkdir -p $redir

usrnodes=$homebase/usrnodes
rm -rf $usrnodes
mkdir -p $usrnodes

usrfiles=$homebase/usrfiles
rm -rf $usrfiles
mkdir -p $usrfiles

## redir
rm -f $redir/usrnodes
ln -s $usrnodes $redir/usrnodes

rm -f $redir/usrfiles
ln -s $usrfiles $redir/usrfiles

for d in $@ ; do
   [ -d "$d" ] || continue
   bd=$(basename $d)

   datatype=${bd%%_*}

   right=${bd#*_}
   usr=${right%%_*}


   [ "$usrname" = "$usr" ] || continue


   case "$datatype" in 
     usrnodes)
        for node in $d/* ; do
            [ -d "$node" ] || continue
            bnode=$(basename $node)
            case "$bnode" in
              *.*.*)
                rm -f $usrnodes/$bnode
                ln -s $node $usrnodes/$bnode
                ;;
              *) : ;;
            esac

        done
       ;;
      usrfiles)
        rm -f $usrfiles/$bd
        ln -s $d $usrfiles/$bd
       ;;
     *)
       :
       ;;
   esac
done
 
##### installing tools
cwd=$(pwd)
basecwd=$(basename $cwd)

## tools
tools=$HOME/tools
mkdir -p  $tools

rm -f $tools/env-pub
ln -s $cwd $tools/env-pub

rm -f $redir/tools
ln -s $tools $redir/tools

rm -f $redir/$basecwd
ln -s $cwd $redir/$basecwd

rm -f $redir/roots
ln -s $roots $redir/roots
