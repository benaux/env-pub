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

## see also fix-permissions.sh
## sets files and folders back to their default permissions

#for directories

find "$inputdir" -type d -print0 | xargs -0 chmod 0755

# for files

find "$inputdir" -type f -print0 | xargs -0 chmod 0644
