#
#
#function fish_user_key_bindings
#     bind \cl clear
#     bind -M default \$ end-of-line accept-autosuggestion
#end
#fish_vi_key_bindings
#set -g fish_escape_delay_ms 10
#
set -U NVIM_LISTEN_ADDRESS /tmp/nvimsocket

#
#" fish_vi_modl
#
# start in insert mode
fish_vi_key_bindings insert

set -x NODE_PATH /usr/local/lib/node_modules

#set FUNCTIONS $HOME/.config/fish/functions
#
set -g JENV_ROOT /usr/local/var/jenv

if [ -f /usr/libexec/java_home ]
   #set -gx JAVA_HOME (/usr/libexec/java_home)
   set -gx JAVA_HOME (/usr/libexec/java_home -v 1.8)
end
set -g JAVA_VERS 1.8
#set -g ANDROID_BUILD_TOOLS_VERS 28.0.2 
#
set -g ANDROID_AVD_HOME $HOME/.android/avd # emulator command / avd needs this

set -g ANDROID_OPT $HOME/opt/android
set -g ANDROID_HOME $HOME/opt/android/sdk
set -g ANDROID_SDK $ANDROID_OPT/sdk
set -g ANDROID_NDK $ANDROID_OPT/ndk

alias emu "$ANDROID_SDK/tools/emulator"

set -g ANDROID_SDK_ROOT $ANDROID_SDK # emulator command / avd needs this


if [ -d $FUNCTIONS ] 
   #echo source $FUNCTIONS/my_fish_vi_key_bindings.fish

#  problems with paste in macosx, therefore disabled:  set -g fish_key_bindings my_fish_vi_key_bindings
end

set -gx GPG_TTY (/usr/bin/tty)

# do I have to run ???
# exec ssh-agent fish 

# PATH
set -gx PATH 
set -l sysbins /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin  /opt/local/bin /usr/local/texlive/2018/bin/x86_64-darwin 

set -l homebins $HOME/local/bin $HOME/.local/bin $HOME/opt/bin $HOME/.bin $HOME/.pub-cache/bin $ANDROID_SDK/tools $ANDROID_SDK/tools/bin $ANDROID_SDK/platform-tools $ANDROID_NDK $HOME/.cargo/bin $HOME/tools/python/bin $HOME/Library/Python/3.7/bin

for bin in $sysbins $homebins
   test -d $bin ; and set -gx PATH $bin $PATH
end

set -gx PATH /Users/bkb/opt/android-sdk/platform-tools $PATH

# opam separate because its messing with the PATH
# set initfile $HOME/.opam/opam-init/init.fish
# [ -f "$initfile" ] ; and source "$initfile" > /dev/null 2> /dev/null ; or true


set config_fish $HOME/.config/fish/conf 
if [ -d $config_fish ] 
   for f in $config_fish/*.fish
      if [ -f $f ] 
         source $f
      end
   end
end

# printf "\e[?2004l"
#echo ppp $PATH
#
#eval (opam env --shell=fish)
eval (opam  config env --shell=fish)

bind \e 'commandline --search-mode || commandline -f cancel'
bind a up-or-search

#source /Users/bkb/Library/Preferences/org.dystroy.broot/launcher/fish/br

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

# opam configuration
source /Users/bkb/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
