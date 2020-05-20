

HELP='create a *.dec file from a dirctory'

USAGE='<directory> <signature> [decimal]'

tools=$HOME/tools
redir=$HOME/base/redir
mkdir -p $redir

directory="$1"
signature="$2"
decimal="$3"

die () { echo $@; exit 1; }

[ -n "$directory" ] || die "usage: $USAGE"
[ -n "$signature" ] || die "usage: $USAGE"

[ -d "$directory" ] || die "Err: invalid input dir $directory" 

[ -d "$tools" ] || die "Err: no tools dir under $tools"

minute_base26_script=$tools/moreutils/stamputils/minute-base26.sh
[ -f "$minute_base26_script" ] || die "Err: no minute-base26 script under $minute_base26_script"

realdir=$(perl -MCwd -le 'print Cwd::realpath($ARGV[0])' "$directory")
basedir=$(dirname $realdir)

namebase= 
if [ -n "$decimal" ]; then 
   namebase="$directory"
else
   bdir=$(basename $directory)
   case "$bdir" in
      *_[0-9][0-9]*) : ;;
      *) 
         bdir=$(basename $basedir)
         case "$bdir" in
            *_*-*_[0-9][0-9]*) 
             die "Err: invalid form ....xx-akakaka_83lka" ;;
            *_[0-9][0-9]*) : ;;
            *) die "Err: a valid decimal is missing"  ;;
         esac
      ;;
   esac

   left=${bdir%%_*}
   right=${bdir##*_}
   case "$right" in 
     *.*) 
         ext=${right##*.}
         namebase=$left.$ext
         ;;
     *)
         namebase=$left
         ;;
   esac

   decimal=${right%.*}
fi

case "$decimal" in 
  [0-9][0-9]*) : ;;
  *) die "Err: invalid decimal $decimal" ;;
esac

minute_base26=$(/bin/sh "$minute_base26_script")
[ -n "$minute_base26" ] || die "Err: could not produce a minute-base26 stamp"

 decfile=${namebase}_${signature}-${minute_base26}_${decimal}.dec


echo "create decfile: $decfile"
echo "inside: $basedir"

[ -f "$basedir/$decfile" ] || touch $basedir/$decfile

rm -f $redir/$decfile
ln -s "$basedir"/$directory $redir/$decfile
