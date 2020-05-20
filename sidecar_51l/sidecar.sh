#!/bin/sh

die () { echo $@; exit 2; }


perlibs=$HOME/libs/perl
sidecar_pm=$HOME/libs/perl/Sidecar.pm

[ -d "$perlibs" ] || die "Err: no perlibs directory in $perlibs"
[ -f "$sidecar_pm" ] || die "Err: no Sidecar.pm Module in $sidecar_pm"

perl -I "$perlibs" "$sidecar_pm"  $@
