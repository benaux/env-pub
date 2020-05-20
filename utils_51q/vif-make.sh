#!/bin/sh

target=$1

cwd=$(pwd)

#[ -n "$target" ] || { echo "usage: <target>"; exit 1; }

[ -n "$target" ] || target=out 

tmux send-keys -t "$target" "cd $cwd && clear ;; make vif" Enter

