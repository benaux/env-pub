#!/bin/sh
# Copyright (c) 2020 ben
# Licensed under the MIT license. See License-MIT.txt in project root.

### Get the an info (URL, title) of the front tab for several browsers
###
### Usage: [ -a --activate ] <action> <object> <browser> [browser arg]"
###
### Options:
### [ -a | --activate ] : activate browser after the action
### <action>: [ get | set ] 
### <object>: [ url | title ]
### <browser>:
###  - 'frontmost' (evaluates one of the below)
###  - 'chrome'
###  - 'canary'
###  - 'chromium'
###  - 'opera'
###  - 'vivaldi'
###  - 'brave'
###  - 'safari'
###  - 'webkit'
###  [browser arg: [ url ]


action_input="$1"
object_input="$2"
browser_input="$3"
browser_arg="$4"

do_activate=

die () { echo "$@" 1>&2; exit 1; }
warn () { echo "$@" 1>&2; }
#help () { echo "Help: $HELP" 1>&2; usage ; }
help () {  /usr/bin/env perl -ne 'print STDERR if ( s/^### ?// )' $0; exit 1; }
#usage () { local app=$(basename $0); die "usage - $app: $USAGE"; }
usage () {
    [ -n "$1" ] && warn "$1";
    u="$(/usr/bin/env perl -ne 'print if (s/^###\s*Usage:\s*?//)' $0)";
    local app=$(basename $0); die "usage - $app: $u";
}
realpath () { perl -MCwd -le 'print Cwd::realpath($ARGV[0])' $1; }
filename () { local n=$(basename $1); echo ${n%.*} ; }
fileext () { local n=$(basename $1); echo ${n##*.} ; }


while [ $# -gt 0 ]; do
   arg="$1"
   shift
   case "$arg" in
      -h|--help) help ;;
      -a|--activate) do_activate=1 ;;
      *) : ;;
  esac
done


[ -n "$action_input" ] || usage
[ -n "$object_input" ] || usage
[ -n "$browser_input" ] || usage


os=$(uname)
case "$os" in
  Darwin) : ;;
  *) die "Todo: OS $os not implemented yet";;
esac

browser_get () {
  local browser="$1"
  local object="$2"

	osascript <<END
tell application "$browser" to return $object of active tab of front window
END
}

browser_set () {
  local browser="$1"
  local object="$2"
  local url="$3"

	osascript <<END
tell application "$browser" to set $object of active tab of front window to "$url"
END
}

get_frontmost () {
   osascript -e 'tell application "System Events" to return  name of first process whose frontmost is true'
}



browser=

get_browser () {
  local browser_inp="$1"

  case "$browser_inp" in
    chrome) browser="Google Chrome";;
    canary) browser="Google Chrome Canary" ;;
    chromium) browser="Chromium";;
    opera) browser="Opera";;
    vivaldi) browser="Vivaldi";;
    brave) browser="Brave Browser";;
    safari) browser="Safari";;
    webkit) browser="Webkit";;
    *)
      warn "Err: '$browser_inp' is not a valid Browser"
      help
      ;;
  esac
}


frontmost_app=
case "$browser_input" in
    frontmost)
      frontmost_app="$(get_frontmost)"
      get_browser "$frontmost_app"
      ;;
    *) 
     get_browser "$browser_input" 
     ;;
esac


case "$action_input" in
   get) 
      object=
      case "$object_input" in
         title) object=title ;;
         url) object=URL ;;
         *) 
          warn "Err: '$object_input' is an invalid <object> input"
          usage
          ;;
      esac

      browser_get "$browser" "$object" 
      ;;
  set) 
      object=
      case "$object_input" in
         title) die "Err: cannot 'set' 'title'";;
         url) object=URL ;;
         *) 
          warn "Err: '$object_input' is an invalid <object> input"
          usage
          ;;
      esac
    if [ -n "$browser_arg" ]; then 
      browser_set "$browser" "$object" "$browser_arg"
    else
      warn "Err: set argument is missing"
      usage
    fi
      ;;
  *)
      warn "Err: '$action_input' is an invalid <action> input"
      usage
      ;;
esac

if [ -n "$do_activate" ] ; then
  osascript<<EOF
tell application "$browser" to activate
EOF
else
  # it can happen that the focus doesn goes back 
  # to the original app
  [ -n "$frontmost_app" ] || frontmost_app="$(get_frontmost)"
  osascript<<EOF
tell application "$frontmost_app" to activate
EOF
fi
