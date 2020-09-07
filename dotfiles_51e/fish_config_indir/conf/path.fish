# setting PATH
# ===========
#
# stuff in ~
set DOTLOCAL_BIN $HOME/.local/bin

set -gx CARP_DIR $HOME/builds/carp/Carp
#
#
#
# tools
# -----


set TOOLSDIR $HOME/tools
set MOREUTILS $TOOLSDIR/moreutils

[ -f $MOREUTILS/aliases.fish ] ; and source $MOREUTILS/aliases.fish
[ -f $TOOLSDIR/functions.fish ] ; and source $TOOLSDIR/functions.fish

set -l DOTNET_MAC_HOME /usr/local/share/dotnet/

set -l toolbins $TOOLSDIR/exotools/bin $TOOLSDIR/utils $MOREUTILS/bin $TOOLSDIR/cmds $TOOLSDIR/symlinks $TOOLSDIR/sw/bin $TOOLSDIR/privutils perl-site/bin $DOTNET_MAC_HOME $TOOLSDIR/bin

for bin in $toolbins $DOTLOCAL_BIN
#  echo bb $bin
   #   test -e $bin ; and set -gx PATH $bin $PATH
   test -d $bin ; and set -gx PATH $bin $PATH
end


# langs 
# -----
set -gx GOPATH $HOME/go

set -x NEWLISPDIR /usr/local/share/newlisp-10.7.1/

set guilelibs /usr/local/Cellar/guile/2.2.4.1/share/guile/2.2/site
test -d $guilelibs ; and set -gx GUILE_LOAD_PATH $guilelibs

#set -l monobin /Library/Frameworks/Mono.framework/Versions/Current/bin/
set -l LLVM_HOME /usr/local/Cellar/llvm/6.0.0/
set -l GO_HOME $HOME/go
set -l CARGO_HOME $HOME/.cargo
set -l RACKET_HOME $HOME/builds/racket/racket
set -l NODE_HOME $HOME/builds/node/node
set -l NIM_HOME $HOME/builds/nim/git/Nim
set -l NIMBLE_HOME HOME/.nimble
set -l CABAL_HOME $HOME/.cabal
set -l GAMBIT_BUILDS_HOME $HOME/builds/gambit/gambit
set -l GAMBIT_HOME /usr/builds/Gambit/
set -l BUILDS_HOME $HOME/builds
set -l NPM_HOME $HOME/.npm-global
set -l GUIX_HOME $HOME/.guix-profile
set -l BIGLOO_HOME $HOME/builds/bigloo/bigloo
set -l MONO_MAC_HOME /Library/Frameworks/Mono.framework/Versions/Current
set -l ARCHIVEBOX_HOME $HOME/builds/archivebox/ArchiveBox
set -l DART_HOME $HOME/builds/dart/dart-sdk
set -l FLUTTER_HOME $HOME/builds/flutter/flutter
set -l SCM_HOME $HOME/builds/scm/scm
set -l CYCLONE_HOME $HOME/builds/cyclone/cyclone
set -l COMPOSER_HOME $HOME/.composer/vendor
set -l COMPOSER_HOME $HOME/.composer/vendor
set -l ZIG_HOME $HOME/builds/zig/zig
set -l PYTHON_HOME_USER $HOME/Library/Python/3.7/
#set -l HASHLINK_HOME $HOME/builds/haxe/hashlink

set -l langhomes $GO_HOME $CARGO_HOME $RACKET_HOME $NODE_HOME $NIM_HOME $NIMBLE_HOME $CABAL_HOME $GAMBIT_HOME $GAMBIT_BUILDS_HOME $BUILDS_HOME $NPM_HOME $GUIX_HOME $LLVM_HOME $BIGLOO_HOME $MONO_MAC_HOME $ARCHIVEBOX_HOME $DART_HOME $FLUTTER_HOME $SCM_HOME $CYCLONE_HOME $COMPOSER_HOME $HASHLINK_HOME $ZIG_HOME $PYTHON_HOME_USER 

for lang in $langhomes
  set bin $lang/bin
  if test -d $bin 
    set -gx PATH $bin $PATH
  else if test -d $lang 
    set -gx PATH $lang $PATH
   else
     echo "Omit: $lang"
   end
  # test -d $bin && echo BBB "'$bin'"
  #echo ll $lang
end

#echo pp $PATH

