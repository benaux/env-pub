#!/bin/sh

browser_from="$1"
browser_to="$2"

die () { echo $@; exit 1; }

[ -n "$browser_from" ] || die "usage: <from> <to>" 
[ -n "$browser_to" ] || die "usage: <from> <to>" 

which pgrep > /dev/null || die "Err: no pgrep installed"

pgrep "$browser_from" > /dev/null || die "Err: $browser_from not running"
pgrep "$browser_to" > /dev/null || die "Err: $browser_to not running"


os=$(uname)

case "$os" in
  Darwin)
    url=$(osascript -e "tell application \"$browser_from\" to return URL of active tab of front window")
    [ -n "$url" ] || die "Err: could not get url $url" 
osascript <<END
    tell application "$browser_to"
    set URL of active tab of window 1 to "$url"
    activate
end tell
END
  ;;
  *)
    die todo browser $os
    ;;
esac



