#!/bin/sh

USAGE='<inputfile>'

inputfile="$1"

cwd=$(pwd)

die () { echo "$@" 1>&2 ; exit 1; }

[ -n "$inputfile" ] || die "usage: $USAGE"

[ -f "$inputfile" ] || touch "$inputfile"


server_name=
if [ -f $cwd/vif.sh ] ; then
  base_name=$(basename $cwd)
  server_name=$(perl -e 'print(uc($ARGV[0]))' "$base_name")
else
  die "Err: no vif.sh file, no project root"
fi


#open -a /Applications/MacVim.app/Contents/MacOS/MacVim "$inputfile"

#exit


os=$(uname)


case "$os" in
  Darwin)
  if which mvim > /dev/null ; then 
     if mvim --serverlist | grep "$server_name" > /dev/null ; then
       # -M :readonly
        #mvim -M --servername VIEW --remote $inp
        mvim  --servername "$server_name" --remote-tab-silent $inputfile &
     else
        mvim  --servername "$server_name" $inputfile &
     fi
  else
    die "Err: no mvim"
  fi
#osascript <<'EOF'
#tell application "System Events"
#   tell  process "MacVim"        
#        set frontmost to true
#       perform action "AXRaise" of (first window whose name contains "VIEW")
#   end tell
#end tell
#EOF
    ;;
  *)
    echo "Err: os $os not implemented yet"
    exit 1
    ;;
esac
