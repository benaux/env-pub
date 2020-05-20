
cwd=$(pwd)

libs=$HOME/libs

bkb=$libs/perl/Bkb

mkdir -p $bkb

rm -f $bkb/Util.pm
ln -s $cwd/Util.pm $bkb/

