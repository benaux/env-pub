#!/bin/sh

msg=$@

tmux send-keys -t out "echo $msg" Enter
