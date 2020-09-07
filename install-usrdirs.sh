
HELP='install folder in ~/usrdir/<folder> including ~/usrdir../inboxes..'

input="$1"

die () { echo $@ 1>&2; exit 1 ; }

homebase=$HOME/base
redir=$homebase/redir
usrfiles=$homebase/usrfiles
usrnodes=$homebase/usrnodes

cwd=$(pwd)
basecwd=$(basename $cwd)

#[ -n "$input" ] || die "usage: [-u user] usr dirs"

mkdir -p $homebase
rm -rf $usrnodes
mkdir -p $usrnodes

rm -rf $usrfiles
mkdir -p $usrfiles

mkdir -p $redir


username= firstdir=
case "$input" in
  -u|--user)
    shift
    username="$1"
    shift
    ;;
  *)
   username=$(whoami)
    ;;
esac

link_usrdirs () {
  local usrdir="$1"

   usrdir_base=$(basename $usrdir)
   usrdir_bname=${usrdir_base%%_*}

   datatype=${usrdir_base%%_*}

   case "$datatype" in 
      usrnodes)
         for node in $d/* ; do
            [ -d "$node" ] || continue

            bnode=$(basename $node)
            case "$bnode" in
               *.*.*)
                  right=${userdir_bname#*.}
                  usr=${right%%.*}
                  if [ "$usrname" = "$usr" ];
                     rm -f $usrnodes/$bnode
                     ln -s $node $usrnodes/$bnode

                     rm -f $redir/$bnode
                     ln -s $node $redir/$bnode
                  then
                     continue
                  fi
                  ;;
                *) : ;;
              esac
          done
         ;;
        usrfiles)
         right=${userdir_bname#*_}
         usr=${right%%_*}
         if [ "$usrname" = "$usr" ]; then 
            rm -f $usrfiles/$usrdir_base
            ln -s $d $usrfiles/$usrdir_base

            rm -f $redir/$usrdir_base
            ln -s $d $redir/$usrdir_base
         else
            continue
         fi
         ;;
       *)
         ;;
     esac
}
   
if [ -n "$1" ] ; then
   for d in $@ ; do
      [ -d "$d" ] || continue
      usrdir=$(dirname $d)
      usrdirbase=$(basename $usrdir)
      case "$usrdirbase" in 
         usrdir_*)
            link_usrdirs "$d"
              ;;
         *) 
            echo "Err: not a valid path, no usrbase: $usrdir"
            exit 1
            ;;
      esac
   done
else
   hname_fqn=$(hostname)
   hname=${hname_fqn%%.*}

   usrdir=$HOME/usrdir_${username}_$hname

   [ -d "$usrdir" ] || die "Err: could not build usrdir in $usrdir"

   for d in $usrdir/*; do
      [ -d "$d" ] || continue
      link_usrdirs "$d"
   done
fi



## tools
tools=$HOME/tools
mkdir -p  $tools

rm -f $tools/$basecwd
ln -s $cwd $tools/$basecwd

rm -f $redir/tools
ln -s $tools $redir/tools

rm -f $redir/usrdir
ln -s $usrdir $redir/usrdir

rm -f $redir/usrnodes
ln -s $usrnodes $redir/usrnodes

rm -f $redir/usrfiles
ln -s $usrfiles $redir/usrfiles





##### installing inboxes

inboxes=$usrdir/inboxes_${username}_${hname}
if [ -d "$inboxes" ] ; then
   binboxes=$(basename $inboxes)
   rm -f $redir/$binboxes
   ln -s $inboxes $redir/$binboxes
   for i in $inboxes/* ; do
      [ -d "$i" ] || continue
      bi=$(basename "$i")
      rm -f $redir/$bi
      ln -s $i $redir/$bi
   done
fi

