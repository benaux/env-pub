#!/bin/sh

##
tools=$HOME/tools
dotfiles=$tools/dotfiles

env_pub=$tools/env-pub_51

homebase=$HOME/base

redir=$homebase/redir

[ -d "$env_pub" ] || {
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

rm -f $redir/base 
ln -s $homebase $redir/base 

mkdir -p $tools
rm -f $redir/tools 
ln -s $tools $redir/tools

mkdir -p $dotfiles
rm -f $redir/dotfiles 
ln -s $dotfiles $redir/dotfiles


link_item_to_dir () {
   local dir=$1
   shift

   for itemd in $@ ; do
     for d in $env_pub/* ; do
       [ -d "$d" ] || continue
       bd=$(basename $d)
       case "$bd" in
         $itemd*)
            rm -f $dir/$itemd
            ln -s $d $dir/$itemd
           ;;
         *) : ;;
       esac
     done
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

for dotdir in ssh gnupg opam; do
   [ -d "$HOME/.$dotdir" ] && {
      rm -f $tools/dotfiles/$dotdir
      ln -s "$HOME/.$dotdir" $tools/dotfiles/$dotdir

      rm -f $redir/.$dotdir
      ln -s "$HOME/.$dotdir" $redir/.$dotdir
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

