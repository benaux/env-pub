
os=$(uname)
cwd=$(pwd)

tools=$HOME/tools
mkdir -p $tools

configs=$tools/configs
mkdir -p $configs

rm -f $configs/tmuxfiles
ln -s $cwd $configs/tmuxfiles

dotfiles=$tools/dotfiles
mkdir -p $tools/dotfiles

die () { echo $@; exit 1; }

os_conf="tmux-${os}.conf" 

rm -f $HOME/.tmux-common.conf
ln -s $cwd/tmux-common.conf $HOME/.tmux-common.conf

rm -f $dotfiles/tmux-common.conf
ln -s $cwd/tmux-common.conf $dotfiles/tmux-common.conf

if [ -f "$os_conf" ] ; then
    rm -f $HOME/.tmux.conf
    ln -s $cwd/$os_conf $HOME/.tmux.conf

    rm -f $dotfiles/tmux.conf
    ln -s $cwd/$os_conf $dotfiles/tmux.conf
else
   echo  "todo ' $os"
fi

