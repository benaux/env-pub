#!/usr/bin/env bash

USAGE='<input> <masterpass>'

Input="$1"
Masterpass_arg="$2"

here=$(dirname $0)

passwordstore="$HOME/.password-store"

tabula_utils=$HOME/tools/tabula-utils
passtab_pw_script=$tabula_utils/passtab-pw.sh
passtab_prefix=user-salts

OS=$(uname)
die () { echo $@; exit 1; }

usage(){
  local baseapp=$(basename $0)
  local app=${baseapp%.*}
  die "usage: $app $USAGE"
}

[ -n "$Input" ] || usage


py=$(which python)
pwdhash_py=$HOME/tools/sw/pwdhash.py
[ -f "$pwdhash_py" ] || die "Err: no pwdhash.py in $pwdhash_py"


clipcopy (){
  case "$OS" in
    Darwin) printf '%s' "$@" | pbcopy ;;
    *) die "TODO(clipcopy): for $OS" ;;
   esac
}

get_masterpass_version () {
  #token: 
  # from pwdhash 'apple,#kbd_u3a0-bkb'      
  # -> login_apple_kbd

  version=$(echo "$Input" | perl -ne '(/,(\w+_p\d\w\d)$/ && print $1 ) || (/,(\w+_)?(u\d\w\d-\w+)$/ && print $2)')


  [ -n "$version" ] || {
     echo "Err: could not extract version from token"
     exit 1
  }

  [ "$version" = "$Input" ] && die "Err: no valid version"

  pwdhash_version="pwdhash/$version"
  echo $pwdhash_version


}

Masterpass= in_pass=
if [ -n "$Masterpass_arg" ] ; then
   Masterpass=$Masterpass_arg
else
   [ -n "$Masterpass" ] || {

      if [ -e "$passwordstore" ] ; then 
         masterpass_version=$(get_masterpass_version)
         Masterpass=$(pass show "$masterpass_version")

         [ "$?" = 0 ] || in_pass=$masterpass_version
         [ -n "$Masterpass" ] || in_pass=$masterpass_version
      else
         echo "Warn: no 'pwdhash' director in ~/.password-store"
      fi
  }
fi

[ -n "$Masterpass" ] || {
  if [ -f "$passtab_pw_script" ] ;then
    version=$(basename $masterpass_version)
    versiontype=$(echo "$version" | perl -ne '(/\w+(_p\d)\w\d$/ && print $1 ) || (/\w+(_u\d)\w\d(-\w+)$/ && print $1. $2)')
    passtab_name=
    case "$versiontype" in
      *_p[0-9])
        passtab_name=profile-salts${versiontype}
        ;;
      *_u[0-9]*)
        passtab_name=user-salts${versiontype}
        ;;
        *) : ;;
    esac

    echo sh "$passtab_pw_script" -i=no "$versiontype"
    passtab_pw=$(sh "$passtab_pw_script" -i=no "$versiontype")

    if [ "$?" = "0" ]; then
      if [ -n "$passtab_pw" ] ; then
        echo "Password part, please enter for the version '$version'"
        read -s password_part
        Masterpass=${password_part}${passtab_pw}
      fi
    fi
  fi
}

[ -n "$Masterpass" ] || {
    echo "Sorry: Please write the entire Masterpass manually"
    read -s Masterpass
}

#echo pp ${py} "$pwdhash_py" "$Input" "Masterpass"

pwhash=$(${py} "$pwdhash_py" "$Input" "$Masterpass")
[ -n "$pwhash" ] || die "Err: could not fetch hash from pwdhash"

#length=$(perl -e 'print(scalar( (split "", $ARGV[0])))' "$Masterpass")

#pwhash_cut=$(echo "$pwhash" | cut -c -$length)

#echo ppp $pwhash

if [ -n "$Masterpass_arg" ] ; then
   #echo "$pwhash_cut"
   echo "$pwhash"
else
   [ -n "$in_pass" ] && {
     [ -n "$Masterpass" ] && {
     echo mmmmm $Masterpass
      clipcopy "$Masterpass"
      echo "Try to insert into pass"
      pass insert "$in_pass"
      }
    }
   #clipcopy "$pwhash_cut"
   clipcopy "$pwhash"
fi

