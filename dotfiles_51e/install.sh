#!/bin/sh

cwd=$(pwd)

dotfiles=$HOME/tools/dotfiles
mkdir -p $dotfiles

trash=$HOME/trash
[ -d "$trash" ] || mkdir $trash

linkfiles (){
   local dir=$1

   for f in $dir/*; do
      bf=$(basename $f)
      if [ -d "$f" ];  then


      case $bf in
        *_files)
         for ff in $f/*; do
            [ -e "$ff" ] || continue
            bff=$(basename $ff)
                     [ -z $bff ] && continue
            t="$trash"/$(date +"%Y%m%d%M%S")
            [ -d "$t" ] || mkdir -p  $t
            [ -e "$HOME/.$bff" ] && { mv $HOME/.$bff $t/ ; }

            rm -f $HOME/.$bff
            ln -s $ff $HOME/.$bff

            rm -f $dotfiles/$bff
            ln -s $ff $dotfiles/$bff
         done
      ;;
      *_dir)
         name=${bf%_*}
         rm -rf $HOME/.$name
         ln -s $f $HOME/.$name

         rm -f $dotfiles/$name
         ln -s $f $dotfiles/$name
      ;;
      *_config_indir)  # non destructive sub folders under ~/.config
         name=${bf%%_*}

         homeconfig=$HOME/.config/$name

         [ -d "$homeconfig" ] || mkdir -p "$homeconfig"

         for ff in $f/*; do
               bff=$(basename $ff)
               [ -e "$ff" ] || continue
               rm -rf  $homeconfig/$bff
               ln -s 	$ff $homeconfig/$bff
           done

         rm -f $dotfiles/$bf
         ln -s $f  $dotfiles/$bf
         ;;
      *_indir)  # non destructive sub folders
         name=${bf%_*}
         homedir=$HOME/.$name
         dotfilesdir=$dotfiles/$name
         [ -d "$homedir" ] || mkdir $homedir 

         [ -d "$dotfilesdir" ] || mkdir $dotfilesdir 

           for ff in $f/*; do
               bff=$(basename $ff)
               [ -e "$ff" ] || continue
               rm -rf  $homedir/$bff
               ln -s 	$ff $homedir/$bff

               rm -rf  $dotfilesdir/$bff
               ln -s 	$ff $dotfilesdir/$bff
           done
      ;;
      *_config)  # destructive sub folders under ~/.config
         name=${bf%_*}

         [ -d "$HOME/.config" ] || mkdir -p $HOME/.config

         homedir=$HOME/.config/$name

           rm -rf $homedir
           ln -s $f $homedir

           rm -f $dotfiles/$name
           ln -s $f $dotfiles/$name

           rm -f $dotfiles/$bf
           ln -s $f $dotfiles/$bf

      ;;
      *)
         echo "Warn: omit directory '$f'"
      ;;
      esac
   else
           [ "$bf" = 'install.sh' ] && continue
           [ "$bf" = 'README.txt' ] && continue

            rm -f $HOME/.$bf
            ln -s $f $HOME/.$bf

            rm -f $dotfiles/$bf
            ln -s $f $dotfiles/$bf
   fi
   done
}

linkfiles $cwd 

os=$(uname)
if [ -d "$os" ] ; then
   linkfiles "$cwd/$os"
fi

if [ -d $HOME/.config ] ; then
   rm -f $dotfiles/config
   ln -s $HOME/.config $dotfiles/config
fi

