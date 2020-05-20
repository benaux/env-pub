#!/bin/sh

inp=$1

[ -n "$inp" ] || { echo "usage: dir" ; exit; }
for f in $(find -L "$inp" -type l); do rm -f  $f; done
