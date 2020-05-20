
root="$1"

[ -n "$root" ] || { echo "usage root" ; exit 1 ; }

sh ./install.sh
sh ./install-nodes.sh  "$root"
sh ./install-decimals.sh
