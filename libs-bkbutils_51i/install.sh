
cwd=$(pwd)

tools=$HOME/tools
mkdir -p $tools

libdir=$tools/libs
mkdir -p $libdir

for d in *; do
   lang=${d%%-*} 
   [ -n "$lang" ] || continue
   
   libdir_lang=$libdir/$lang

   if [ -d "$d" ] ; then 
     case "$d" in
        *-Bkb-Utils) 
          mkdir -p $libdir_lang/Bkb
          rm -f $libdir_lang/Bkb/Utils
          ln -s $cwd/$d $libdir_lang/Bkb/Utils
          ;;
        *-bkb-utils) 
          mkdir -p $libdir_lang/bkb
          rm -f $libdir_lang/bkb/utils
          ln -s $cwd/$d $libdir_lang/bkb/btils
          ;;
        *-bkbutils) 
          mkdir -p $libdir_lang
          rm -f $libdir_lang/bkbutils
          ln -s $cwd/$d $libdir_lang/bkbutils
          ;;
        *) continue ;;
     esac
   elif [ -f "$d" ] ; then 
     case "$d" in
        *-Bkb-Utils.*) 
          bn=${d##*-}
          mkdir -p $libdir_lang/Bkb
          rm -f $libdir_lang/Bkb/$bn
          ln -s $cwd/$d $libdir_lang/Bkb/$bn
          ;;
        *-bkb-utils.*) 
          bn=${d##*-}
          mkdir -p $libdir_lang/bkb
          rm -f $libdir_lang/bkb/$bn
          ln -s $cwd/$d $libdir_lang/bkb/$bn
          ;;
        *-bkbutils.*) 
          bn=${d##*-}
          mkdir -p $libdir_lang/
          rm -f $libdir_lang/$bn
          ln -s $cwd/$d $libdir_lang/$bn
          ;;
        *)
         echo "omit: $d"
          continue
          ;;
      esac
    else
      continue
   fi
done

