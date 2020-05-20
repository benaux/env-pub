#!/bin/sh

input="$@"

decrefs=$HOME/.decrefs

die (){ echo $@; exit 1; }

[ -n "$input" ] || { echo "usage: input"; exit 2; }
[ -d "$input" ] || die "Err: no $input no dir  " ;

case "$input" in
  *dir_*_*_*) : ;;
  *)
    die "Err: $input doesnt' look like a grpdir/usrdir"
    ;;
esac

redir=$HOME/base/redir
mkdir -p $redir
rm -f ~/r
ln -s $redir ~/r

# homedirs
mkdir -p $HOME/tools $HOME/libs $HOME/share 


for homedir in tools libs share Downloads Music Pictures Library local opt hacks ; do
  [ -d "$HOME/$homedir" ] || continue
  rm -f $redir/$homedir
  ln -s $HOME/$homedir $redir/$homedir
done


subfolders () {
  local d=$1

  for dd in $d/*; do
    [ -d "$dd" ] || continue

    #echo dd $dd

    local bdd=$(basename $dd)

    local decnum=${bdd##*_bk}

    local userdec=_bk${decnum}

    mkdir -p $redir/a


    case "$bdd" in 
      *_bk[0-9][0-9].[a-z]*.[a-z]|*_bk[0-9][0-9].[0-9]*) 
         echo "$userdec: $dd" >> $decrefs
         rm -f $redir/a/"$bdd"
         ln -s $dd $redir/a/$bdd
        continue 
        ;; ## skip sub sub folders
      *_bk[0-9][0-9].[a-z]*.[0-9]*) : ;;
      *_bk[0-9]*.[a-z]*) : ;;
      *_bk[0-9]x) : ;;
      *_bk[0-9][0-9]) : ;;
      *_bk[0-9][0-9]-[0-9][0-9]) : ;;
      *_bk*) continue ;;
      *) continue;;
    esac

         echo "$userdec: $dd" >> $decrefs
         rm -f $redir/a/"$bdd"
         ln -s $dd $redir/a/$bdd

        rm -f $redir/$bdd
       ln -s $dd $redir/$bdd


  subfolders $dd
  done
}


for root in $input/*; do
  [ -d "$root" ] || continue


   baseroot=$(basename $root)
  case "$baseroot" in
    *-*.*.*) : ;;
    *) continue ;;
  esac


  for d in $root/*; do
      [ -d "$d" ] || continue
      bd=$(basename $d)
      case "$bd" in
        *_bk[0-9][0-9]) : ;;
        *_bk[0-9][0-9]-[0-9][0-9]) : ;;
         *) continue ;;
      esac


  case "$bd" in *\/archive*) continue ;; esac

  decnum=${bd##*_bk}
  decgroup=
  case "$decnum" in
    0*|1*|2*|3*|4*) decgroup=info ;;
    5*|6*) decgroup=material ;;
    7*|8*) decgroup=aux ;;
    9*) decgroup=work ;;
    *) continue ;;
  esac

  userdec=_bk${decnum}

  echo "$userdec: $d" >> $decrefs


  mkdir -p $redir/$decgroup
  rm -f $redir/$decgroup/$bd
  ln -s $d $redir/$decgroup/$bd

  rm -f $redir/$bd
  ln -s $d $redir/$bd

  #name=${bd%_bk*}

 subfolders $d

done
done
