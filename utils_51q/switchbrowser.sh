#!/bin/sh

url=$(/usr/bin/osascript -e 'tell application "Vivaldi" to return URL of active tab of front window')


/usr/bin/osascript -e "tell application \"Google Chrome\" to set URL of active tab of window 1 to \"$url\""
