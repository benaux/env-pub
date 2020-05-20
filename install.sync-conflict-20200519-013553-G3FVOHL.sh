#!/bin/sh

##
tools=$HOME/tools

env_pub=$tools/env-pub

homebase=$HOME/base

redir=$homebase/redir

[ -d "$tools/env-pub" ] || {
  echo "Err: first run 'sh ./install-tools.sh' from 'env-pub'"
   exit 1;
 }

os=$(uname)

cp_link () {
  case "$os" in
    Darwin) cp -a $@ ;;
    *) cp --preserve=links $@ ;;
    esac
}

# homebase
mkdir -p $homebase

# redir
mkdir -p $redir
rm -f ~/r && ln -s $redir ~/r

rm -f $redir/base 
ln -s $homebase $redir/base 

rm -f $redir/tools
rm -f $redir/base && ln -s $homebase $redir/base 

tools=$HOME/tools
mkdir -p $tools
rm -f $redir/tools 
ln -s $tools $redir/tools


link_item_to_dir () {
   local dir=$1
   shift

   for itemd in $@ ; do
      rm -f $dir/$itemd
      ln -s $env_pub/$itemd $dir/$itemd
   done
}


link_item_to_dir $tools templates cheats utils


## running installers in sub dirs
for d in * ; do
   [ -d "$env_pub/$d" ] || continue 
   bd=$(basename $d)

   if [ -f "$d/install.sh" ] ; then
     echo goto $d
      cd "$env_pub/$d" 
      sh ./install.sh
      cd $env_pub
   fi

   #echo rrrr rm -f $redir/$bd
   #echo xxxx ln -s $env_pub/$d $redir/$bd
done

exit
## redir
# home link : from ~/ to redir/
for d in hacks Documents Desktop Photos Pictures Downloads local share Dropbox Music ; do
   [ -d "$HOME/$d" ] || continue
   rm -f $redir/$d
   ln -s $HOME/$d $redir/$d
done

for d in $homebase/* ; do
   [ -d "$d" ] || continue
   bd=$(basename $d)

   [ "$bd" = "redir" ] || {
      rm -f $redir/$bd
      ln -s $d $redir/$bd
    }
done

for dotdir in ssh gnupg; do
   [ -d "$HOME/.$dotdir" ] && {
      rm -f $tools/dotfiles/$dotdir
      ln -s "$HOME/.$dotdir" $tools/dotfiles/$dotdir
   }
done

for d in $tools/dotfiles/*; do
  [ -d "$d" ] || [ -f "$d" ] || continue
   bd=$(basename $d)
   reald=$(perl -MCwd -le 'print Cwd::realpath($ARGV[0])' $d)
   [ -n "$reald" ] || { echo "Err: reald " ; exit 1; }
   rm -f $redir/.$bd
   ln -s $reald $redir/.$bd
done

