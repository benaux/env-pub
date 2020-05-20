set TOOLS "$HOME/tools" 
set UTILS "$TOOLS/utils"
set CMDS "$TOOLS/cmds"
set MOREUTILS "$TOOLS/moreutils"
set MOREUTILSBIN "$TOOLS/moreutils-bin"

function el; elinks -remote "openURL($argv)"; end

alias so-filter 'perl $MOREUTILS/downloads/so-filter.pl'

alias download-music "youtube-dl --extract-audio --audio-format mp3"
alias dm "download-music"

#alias urn "luajit $HOME/builds/urn/urn/bin/urn.lua"


alias install-decimals "sh ~/tools/env-pub/install-decimals.sh"

alias decls "sh $TOOLS/moreutils/decimalutils/decls.sh"
alias decget "sh $TOOLS/moreutils/decimalutils/decget.sh"

alias fifo "sh $UTILS/fifo.sh"


set XCODE "/Applications/Xcode.app/Contents/Developer"
alias ios_clang "$XCODE/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"

alias haskeme "/Users/bkb/.cabal/bin/haskeme"

alias obt $CMDS/org-babel-tangle

alias dev-sw-opensource "sh $MOREUTILS/devutils/sw-opensource.sh"

alias ssh-load-ssh-keys "sh $MOREUTILS/ssh/load_ssh_keys.sh"
alias twikpw "perl $UTILS/twikpw.pl"
alias pwdhash "bash $TOOLS/moreutils/crypto/pwdhash.bash"
alias pwh pwdhash
alias pwcalc "sh $TOOLS/moreutils-bin/pwcalc.sh"
alias ssh-createkey "sh $TOOLS/moreutils-bin/ssh-createkey.sh"
alias hxrun "sh $TOOLS/moreutils/haxe/hxrun.sh"

set d del

alias sd "$UTILS/searchdir"
alias mo "$UTILS/move"

alias rn "rename"

alias pc "$UTILS/pwdcopy"

function realcd 
   cd (realpath (pwd))
end

function j 
   set jdir (/bin/sh $HOME/aux/utils/java-switch $argv[1])
   set -gx JAVA_HOME "$jdir"
   echo run java -version
end


function m
   mkdir -p $argv[1] ; and cd $argv[1]
end


function die
   echo $argv
   exit 1
end

function go_to_stdout
   set out (/bin/sh $HOME/aux/utils/stdout)
   echo out $out
   if [ -d "$out" ] 
      cd "$out"
   else if [ -f "$out" ]
      switch "$out"
         case *.html
            open "$out"
         case '*'
            open -a MacVim "$out"
         end
   else
       echo "Warn: no file of dir"
   end
end

# alias go "go_to_stdout"

alias gtr 'go_to_res'


alias aa "archive-article"

alias . "ls ."
alias fm "urxvtc -e /usr/local/bin/vifm"


alias xreload "xrdb ~/.Xresources"
alias cdd "cd ~/dev/"
alias cdi "cd ~/dev/i"
alias cdr "cd ~/dev/repos"

alias now 'date "+%F %T"'

alias sf "showfile"

alias u untar

alias ssh-restart "sudo service ssh restart"
alias sshr ssh-restart

alias apts "apt-cache search"
alias apti "sudo apt-get install"
alias aptu "sudo apt-get update"

alias chmox "chmod 0755"

#alias copy "xclip -sel clip"
#alias paste "xclip -sel clip -o"


#alias ack "ack-grep"

alias upl "/home/bkb/builds/perl/upl/upl -I /home/bkb/builds/perl/upl/lib"

alias l "ls | grep -v \.plist"
alias ll "ls -al | grep -v \.plist"
#alias l "ls -Fhtlr | grep -v \.plist"
alias sl "ls"


alias worg "mvim --remote-silent"

alias lizpop "python -O -m lizpop.run"
alias lp "python -O -m lizpop.run"

# tmux
alias tmuxlist "tmux list-sessions"
alias txl tmuxlist
alias tmuxl tmuxlist

alias mp "mkdir -p "
alias mkdri "mkdir -p"

alias shortdate 'date +"%Y-%m-%d"'

alias sshkeyless "ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no"

function go_to_item
   set target $argv[1]
   set item $argv[2]

   set dir (/bin/sh $TOOLS/utils/decimals/get-id.sh "$target" "$item")
   if [ -d "$dir" ] 
     echo Change to $dir
     cd $dir
   else
     echo Cannot change dir
   end
end

function go_to_item_parent
   set target $argv[1]
   set item $argv[2]

   set dir (/bin/sh $TOOLS/moreutils/decimals/get-id.sh "$target" "$item")
   if [ -d "$dir" ] 
     echo "Change to '$target' $dir"
     cd (dirname $dir)
   else
     echo Cannot change dir
   end
end

function show_item
   set target $argv[1]
   set item $argv[2]

   set dir (/bin/sh $TOOLS/moreutils/decimals/get-id.sh "$target" "$item")
   if [ -d "$dir" ] 
     echo $dir
   else
     echo Cannot Show 
   end
end


function link_to_item
   set target $argv[1]
   set folder $argv[2]

   set targetdir (/bin/sh $TOOLS/moreutils/decimals/get-id.sh $target $folder)

   if [ -d "$targetdir" ] 
     set btarget (basename $targetdir)
     rm -f $btarget.$target
     ln -s $targetdir $btarget.$target
     echo "link target '$targetdir' to '$btarget.$target'"
   else
     echo Cannotx change dir
   end
end

function link_to_item_parent
   set target $argv[1]
   set folder $argv[2]

   set targetdir (/bin/sh $TOOLS/moreutils/decimals/get-id.sh $target $folder)
   set targetdirparent (dirname $targetdir)

   if [ -d "$targetdirparent" ] 
     set btarget (basename $targetdirparent)
     rm -f $btarget.$target
     ln -s $targetdirparent $btarget.$target
     echo "link target parent '$targetdirparent' to '$btarget.$target'"
   else
     echo "Cannotx link dir '$targetdir'"
   end
end

alias gi 'go_to_item'
alias gip 'go_to_item_parent'

alias li 'link_to_item'
alias lip 'link_to_item_parent'

alias si 'show_item'

alias refish "source $HOME/.config/fish/config.fish"
alias 'decimal-link' "sh $TOOLS/moreutils/decimals/link-decimal.sh"

alias 'clean-filename' "sh $HOME/r/utils/clean-filename.sh"
alias 'filename-clean' "sh $HOME/r/utils/clean-filename.sh"

function resource 
   source ~/tools/moreutils/aliases.fish
end


set ONETOOLS "$HOME/tools/autoscripts/onetools"
alias 'one-vim' "sh $ONETOOLS/one-vim.sh"

alias 'webref-dl' "bash $INFOTOOLS/webref-dl.bash"
# webref-dl.bash
# one-last-line.sh
# one-last-show.sh
# one-ls.sh
# one-new.sh
# one-read-stamp.sh

set DECIMALS $MOREUTILS/decimals_bk71.45.16
alias 'dec-id' "sh $DECIMALS/dec-id.sh" 
alias 'dec-folder-id' "sh $DECIMALS/dec-folder-id.sh" 

alias 'ssh-load-key' "sh $MOREUTILSBIN/ssh-load-key.sh"

#alias love "/Applications/love.app/Contents/MacOS/love"

alias opam-reset "eval (opam env --shell=fish)"

alias day-stamp-base "sh $HOME/tools/moreutils/stamps/day-stamp-base26.sh"
alias dsb day-stamp-base

alias msec-stamp-crock "sh $HOME/tools/moreutils/stamps/msec-stamp-crock.sh"
alias msc msec-stamp-crock

alias stamp-minute-base "sh $HOME/tools/moreutils/stamps/minute-base26.sh"
alias smb stamp-minute-base

alias min-stamp-year-base "sh $HOME/tools/moreutils/stamps/stamp-year-base26.sh"
alias myb min-stamp-year-base

alias stamp-minute "sh $HOME/tools/moreutils/stamps/minute.sh"
alias sm stamp-minute

alias sec-stamp-base "sh $HOME/tools/moreutils/stamps/sec-stamp-base26.sh"
alias sb sec-stamp-base

alias msec-stamp-base "sh $HOME/tools/moreutils/stamps/msec-stamp-base26.sh"
alias msb msec-stamp-base

alias mygosh "sh ~/tools/moreutils/gauche/mygosh.sh"
#alias mygosh "/usr/bin/env gosh -I $HOME/libs/gauche/"
alias morsgosh "sh /Users/bkb/r/tools/moreutils/gauche/morsgosh.sh"
alias mg morsgosh 

function decref
   set path  (/bin/sh "$HOME/r/moreutils-tools_bk71.h/dec/decref.sh" $argv)
   if [ -d "$path" ] 
     cd "$path"
   end
end

alias dr decref

alias cdreal "cd (realpath (pwd))"
