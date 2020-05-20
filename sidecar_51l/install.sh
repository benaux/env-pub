cwd=$(pwd)

tools=$HOME/tools

libs=$tools/libs
mkdir -p $libs
rm -f $HOME/libs && ln -s $libs $HOME/libs

perlibs=$libs/perl
mkdir -p $perlibs

rm -f $perlibs/Sidecar*
ln -s $cwd/Sidecar* $perlibs/


mkdir -p $tools/bin
rm -f $tools/bin/sidecar
ln -s $cwd/sidecar.sh $tools/bin/sidecar


