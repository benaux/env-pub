

inputdir="$1"

homebase=$HOME/base

decdirs=$homebase/decdirs
mkdir -p $decdirs

redir=$homebase/redir
mkdir -p $redir
rm -f $redir/decdirs
ln -s $decdirs $redir/decdirs

inputdir_base=$(basename $inputdir)

rm -f $decdirs/$inputdir_base
ln -s $inputdir $decdirs/$inputdir_base

