
cwd=$(pwd)


sec_dir=$HOME/base/decimals/security

realpath () {
  perl -MCwd -le 'print Cwd::realpath($ARGV[0])' $1 
}

for d in $sec_dir/*; do
  [ -d "$d" ] || continue
  [ -f "$d/install.sh" ] && {
    reald=$(realpath $d)
   [ -d "$reald" ] || continue
    echo cd "$reald"
    cd "$reald"
    sh ./install.sh
    cd $cwd
   }
done

for d in $tools/dotfiles/*; do
  [ -d "$d" ] || [ -f "$d" ] || continue
   bd=$(basename $d)
   reald=$(realpath $d)
   [ -n "$reald" ] || { echo "Err: reald " ; exit 1; }
   rm -f $redir/.$bd
   ln -s $reald $redir/.$bd
done
