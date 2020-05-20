#!/bin/sh

cwd=$(pwd)

tools=$HOME/tools

dotfiles=$tools/dotfiles

mkdir -p $dotfiles
rm -f $tools/vimfiles && ln -s $cwd $tools/vimfiles


for n in  * ; do
  bn=$(basename $n)

		case "$n" in
			vim*)
		    bn=${n%_*}
        if [ -d "$n" ] ; then
				  rm -f $HOME/.$bn
				  ln -s $cwd/$n $HOME/.$bn

				  rm -f $dotfiles/$bn
				  ln -s $cwd/$n $dotfiles/$bn

        elif [ -f "$n" ] ; then
	        rm -f $HOME/.$bn
	        ln -s $cwd/$n $HOME/.$bn

	        rm -f $dotfiles/$bn
	        ln -s $cwd/$n $dotfiles/$bn
        else
	        continue
        fi
        ;;
    *) : ;;
  esac
done

# neovim

nvim_home=$HOME/.config/nvim

if [ -d "$nvim_home" ] ; then
   rm -rf $nvim_home
else
   rm -f $nvim_home
fi
ln -s $HOME/.vim $nvim_home
rm -f $nvim_home/init.vim
ln -s $HOME/.vimrc $nvim_home/init.vim
   

