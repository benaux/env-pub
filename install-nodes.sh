
dirroot="$1"
[ -d "$dirroot" ] || { echo "usage dir root"; exit 1; }
dirbase=$(basename $dirroot)

homebase=$HOME/base

dirs=$homebase/dirs

userdirs=$homebase/usrdirs
userdirs_others=$homebase/usrdirs-others

nodes=$homebase/nodes
nodes_others=$homebase/nodes-others

here=$(hostname)

die () { echo $@; exit 1; }

# base
mkdir -p $homebase

# roots: my roots
rm -f $homebase/roots
ln -s $dirroot $homebase/roots

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


   # check if the dir has the samv hostname
   case "$here" in
      $bdir_place|$bdir_place.*) : ;;
      *) continue ;;
   esac

   # usrserv_bkb_webdav_lan-data_p2p_skyfall
   # diruser=$(perl -e '$ARGV[0] =~ /[a-z]+_([a-z]+)_[a-z]+_\w+/ && print $1' $bdir)

   #dirtype=${bdir%%_*}
   case $bdir in
      *_*_*_*_*_*)  # usrserv_bkb_webdav_lan-data_p2p_skyfall
         datatype=$(perl -e '$ARGV[0] =~ /[a-z]+_[a-z]+_[a-z]+_([a-z0-9]+)_\w+/ && print $1' $bdir)
         case "$datatype" in 
            nodes|nodes[0-9]) install_nodes $dir ;; 
            *) : ;;
         esac
      ;;
      *_*_*_*_*|*_*_*_*)  # usrdir_bkb_nodes1_p2p_skyfall
         datatype=$(perl -e '$ARGV[0] =~ /[a-z]+_[a-z]+_([a-z0-9]+)_\w+/ && print $1' $bdir)
         case "$datatype" in 
            nodes|nodes[0-9]) install_nodes $dir ;; 
            *) : ;;
         esac
      ;;
      *)
         :
      ;;
   esac
done
