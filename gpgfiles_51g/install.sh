#!/bin/sh

cwd=$(pwd)

tools=$HOME/tools
mkdir -p $tools

rm -f $tools/gpgfiles
ln -s $cwd $tools/gpgfiles

mkdir -p ~/.gnupg
chmod 0700 ~/.gnupg

os=$(uname)

[ -n "$os" ] || { echo "Err: no valid os " ; exit 1; }
[ -d "$os" ] || { echo "Err: no dir for os " ; exit 1; }

for f in ${os}/* ; do
   [ -f "$f" ] || continue
   basef=$(basename $f)
   rm -f ~/.gnupg/$basef
   cp $f ~/.gnupg/     # there were problems with symlinks
done

chmod 0600 ~/.gnupg/*

# dotfiles
dotfiles=$tools/dotfiles
mkdir -p $dotfiles
rm -f $dotfiles/gnupg
ln -s $HOME/.gnupg $dotfiles/gnupg
