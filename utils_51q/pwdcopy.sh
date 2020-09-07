#!/bin/sh


os=$(uname)


case "$os" in
  Darwin)
    pwd | perl -ne 'chomp; print;' | pbcopy
    ;;
  *)
    echo "Err: os $os not implemented yet"
    ;;
esac

