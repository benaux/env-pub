
dirroot="$1"
[ -d "$dirroot" ] || { echo "usage dir root"; exit 1; }
dirbase=$(basename $dirroot)

homebase=$HOME/base

dirs=$homebase/dirs

userdirs=$homebase/userdirs
userdirs_others=$homebase/userdirs-others

nodes=$homebase/nodes
nodes_others=$homebase/nodes-others

here=$(hostname)

die () { echo $@; exit 1; }

# base
mkdir -p $homebase

# dirs: my dirs
rm -f $homebase/dirs
ln -s $dirroot $homebase/dirs

# userdirs
mkdir -p $userdirs

# userdirs-others
mkdir -p $userdirs_others

# nodes
mkdir -p $nodes

# nodes-others: other nodes
mkdir -p $nodes_others

me=$(whoami)

install_nodes () {
   local dir=$1

   for node in "$dir"/* ; do
      [ -d "$node" ] || continue
      bnode=$(basename "$node")
      datatype=$(perl -e '$ARGV[0] =~ /\w+\-([[:alpha:]]+)?([_\w]*)\.\w+\.\w+/ && print $1' $bnode)
      case $datatype in
         data|store)
            nodeuser=$(perl -e '$ARGV[0] =~ /\w+\-\w+\.(\w+)\.\w+/ && print $1' $bnode)

            [ "$nodeuser" = "$me" ] && {
               rm -f $nodes/$bnode
               ln -s $node $nodes/$bnode
             }
            ;;
         *) : ;;
      esac
   done
}

for dir in $dirroot/* ; do 
   [ -d "$dir" ] || continue

   bdir=$(basename $dir)
   bdir_place=${bdir##*_}

   dirtype=${bdir%%_*}

   # check if the dir has the samv hostname
   case "$here" in
      $bdir_place|$bdir_place.*) : ;;
      *) continue ;;
   esac

   # userdir_bkb_data_local_skyfall/  userdir_bkb_nodes_peer1_skyfall

   case $dirtype in
      backupdir) : ;;
      userdir)
         diruser=$(perl -e '$ARGV[0] =~ /[a-z]+_([a-z]+)_[a-z]+_\w+/ && print $1' $bdir)
         datatype=$(perl -e '$ARGV[0] =~ /[a-z]+_[a-z]+_([a-z]+)_\w+/ && print $1' $bdir)

         case "$datatype" in 
            nodes)
               install_nodes $dir
            ;; 
            *) : ;;
         esac
         ;;
       *) : ;;
      esac
done
