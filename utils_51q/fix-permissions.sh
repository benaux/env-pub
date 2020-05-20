#!/bin/sh
inputdir="$1"

[ -n "$inputdir" ] || {
  echo "usage: <input dir>"
   exit 1
}
[ -d "$inputdir" ] || {
  echo "Err: invalid dir"
   exit 1
}

## see also default-permissions.sh
## sets files and folders back to their default permissions

#for directories
find -L "$inputdir"/ -type d -print0 | xargs -0 -I{}  chmod 0755 {}

# for files

find -L  "$inputdir"/ -type f -print0 | xargs -0 -I{} chmod 0644 {}
