
cwd=$(pwd)
basecwd=$(basename $cwd)

tools=$HOME/tools
rm -rf $tools
mkdir -p  $tools

rm -f $tools/env-pub
ln -s $cwd $tools/env-pub

# redir
redir=$HOME/base/redir
mkdir -p $redir

rm -f $redir/tools
ln -s $tools $redir/tools

rm -f $redir/$basecwd
ln -s $cwd $redir/$basecwd

