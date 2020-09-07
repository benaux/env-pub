#!/bin/sh

USAGE='<tooldir/profiledir>  <keyuser> <signature>' 

keydir_path="$1"
keyuser="$2"
signature="$3"

cwd=$(pwd)

die () { echo $@; exit 1; }

twikpw () { # cmd used below
  perl $HOME/tools/moreutils/secutils/twikpw.pl $@
  if [ "$?" -eq "0" ] ; then 
     echo "Ok: Password successfully stored in clipboard"
   else
     die  "Err: could not fetch password with cmd '$pw_cmd'"
  fi
}

[ -n "$keydir_path" ] || die "usage: $USAGE"
[ -d "$keydir_path" ] || die "Err: invalid dir"

[ -n "$keyuser" ] || die "usage: $USAGE"
[ -n "$signature" ] || die "usage: $USAGE"

here=$(basename $cwd)
herename=${here%_*}

keydomain=
case "$herename" in
  ssh-hostkeys) 
    keydomain=hostkey;;
  ssh-cloudkeys) 
    keydomain=cloudkey;;
  *) die "Err: unknown keydomain (probäbly script started from wrong location) $here"
esac

keydir_base=$(basename $keydir_path)
keydir=$(dirname $keydir_path)
keydir_dir_base=$(basename $keydir)

tool=${keydir_dir_base%_*}
tooldir=$keydir_dir_base/$keydir_base

minute_stamp=$(date +"%Y%m%d%H%M")

stamp=${minute_stamp}-${signature}

keyname= keytarget=
case $keydomain in
  cloudkey)
      keyname=cloudkey-${keyuser}_${stamp}
      keytarget=cloudkey-${keyuser}
    ;;
  hostkey)
    fqhostname=$(hostname)
    hname=${fqhostname%%.*}
    
      keyname=hostkey-${keyuser}-${hname}_${stamp}
      keytarget=hostkey-${keyuser}
    ;;
  *) die "Err: invalid directory root '$here'";;
esac



keypath=$keydir_path/$keyname
#die keypath $keypath
[ -f "$keypath" ] && die "Err: key '$keypath' already exists"

profile=${keydir_base}
pw_cmd=
case $tool in
  twikpw)
    pw_cmd="twikpw _ssh,$keytarget $profile"
    ;;
  pwdhash)
    # ssh/ , slashes doesnt work on ipads Password
    #pw_cmd="pwdhash ssh/${keytarget}_${profile}"

    pw_cmd="pwdhash _ssh,${keytarget}_${profile}"
    ;;
  *)
    die "Err: no tool $tool"
    ;;
esac


echo ${pw_cmd}
${pw_cmd}

echo ""

#echo ssh-keygen -t rsa -b 4096 -C "$keyname.pub in $tooldir :: ~/.ssh/$keytarget.pub :: $pw_cmd" -f "$keypath" 
#exit 

# there are problems with -t dsa
#https://discussions.apple.com/thread/7676756

## ssh-keygen -t rsa -b 4096 -C "$keyname.pub in $tooldir :: ~/.ssh/$keytarget.pub :: $pw_cmd" -f "$keypath" 
ssh-keygen -t rsa -b 4096 -C "$keyname.pub in $tooldir :: ~/.ssh/$keytarget.pub :: $pw_cmd" -f "$keypath" 

chmod 0600 $cwd/$keypath
chmod 0644 $cwd/$keypath.pub


echo "OK: key successfully generated" 

   [ -d "$HOME/.ssh" ] && {
   echo "OK: now linking to ~/.ssh/"

   ssh_key=$HOME/.ssh/$keytarget
   public_key=$ssh_key.pub

   rm -f $ssh_key
   cp $cwd/$keypath $ssh_key
   chmod 0600 $ssh_key

   rm -f $public_key
   cp $cwd/$keypath.pub $public_key 
   chmod 0644 $public_key
  }

