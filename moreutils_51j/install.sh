cwd=$(pwd)

tools=$HOME/tools
mkdir -p $tools

moreutils=$tools/moreutils
rm -rf $moreutils && ln -s $cwd  $moreutils

libs=$tools/libs
mkdir -p $libs

bkb_perl_libs=$libs/perl/Bkb
mkdir -p $bkb_perl_libs
rm -f $bkb_perl_libs/Moreutils
ln -s $cwd/perl-Bkb-Moreutils $bkb_perl_libs/Moreutils


sec=$tools/sec
mkdir -p $sec
rm -f $sec/cryptoutils
ln -s $cwd/cryptoutils $sec/cryptoutils

