

cwd=$(pwd)
cwd_base=$(basename $cwd)

homebase=$HOME/base

tools=$HOME/tools
mkdir -p $tools

rm -f $tools/morelibs
ln -s $cwd $tools/morelibs


#redir
redir=$homebase/redir
mkdir -p $redir

rm -f $redir/$cwd_base
ln -s $cwd $redir/$cwd_base

rm -f $redir/tools
ln -s $tools $redir/tools

