#!/bin/sh

HELP=''
USAGE=''

# Copyright (C) 2017 2019 bkb@auxdir.com 
# Licensed under the MIT license. See License-MIT.txt

die () { echo $*; exit 1; }
usage () { local app=(basename $0); die "usage: $app $USAGE"; }
	
std="./std.sh"
[ -f "$std" ] || std=$HOME/tools/lib/std.sh
[ -f "$std" ] || die "Err: no std.sh under $std"
source $std
