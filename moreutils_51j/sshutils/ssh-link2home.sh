#!/bin/sh

dir_arg=$1
usr_arg=$2

user=
if [ -n "$usr_arg" ] ; then
  user=$usr_arg
else
  user=${USER}
fi


cwd=$(pwd)
cwdbase=$(basename $cwd)

sshdir=$HOME/.ssh
mkdir -p "$sshdir"

redir=$HOME/base/redir
mkdir -p $redir
rm -f $HOME/r
ln -s $redir $HOME/r


rm -f $redir/.ssh
ln -s $sshdir $redir/.ssh

die () { echo $@; exit 1; }

[ -d "$dir_arg" ] || die "Err: is not a dir: '$dir_arg' "

dir=
case "$dir_arg" in 
  /*) dir="$dir_arg";;
  *) dir="$cwd/$dir_arg";;
esac

[ -d "$dir" ] || die "Err: is not a dir: '$dir' "

sshdir=$HOME/.ssh

fqhname=$(hostname)
hname=${fqhname%%.*}

keytype=
case "$cwdbase" in
  ssh-cloudkeys_*)
    keytype=cloud
    ;;
  ssh-hostkeys_*)
    keytype=host
    ;;
  *)
    die "Err: could not detect keytype in '$cwdbase'";
    ;;
esac
    
for pubkey in "$dir"/*.pub; do
   [ -f "$pubkey" ] || continue

   basepubkey=$(basename "$pubkey")
   baseprivkey=${basepubkey%.*}

   privkey=$dir/$baseprivkey
   [ -f "$privkey" ] || die "Err: no private key for '$privkey'"

   chmod 0600 $privkey
   chmod 0644 $pubkey

   if [ "$keytype" = 'host' ]; then
     hostkey=hostkey-$user
     case $baseprivkey in
       ${hostkey}-${hname}_*)
        rm -f "$sshdir/$hostkey"
        ln -s $privkey $sshdir/$hostkey

        rm -f "$sshdir/$hostkey".pub
        ln -s $pubkey $sshdir/$hostkey.pub
        ;;
      *)
        die "Err: something wrong with the key format '$baseprivkey' for '${hostkey}-${hname}_"
        ;;
    esac
  else
    keyname=${baseprivkey%_*} 
   case "$keyname" in
     cloudkey-*)
       rm -f $sshdir/$keyname
       ln -s $privkey $sshdir/$keyname

       rm -f $sshdir/$keyname.pub
       ln -s $pubkey $sshdir/$keyname.pub
       ;;
     *)
       die "Err: this key format should be: 'clouds_[name]_[stamp]'"
       ;;
   esac
  fi
done

