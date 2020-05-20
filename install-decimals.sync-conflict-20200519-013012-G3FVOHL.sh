


homebase=$HOME/base
mkdir -p $homebase

redir=$homebase/redir
mkdir -p $redir

usrnodes=$homebase/usrnodes
mkdir -p $usrnodes
rm -f $redir/usrnodes
ln -s $usrnodes $redir/usrnodes

usrdirs=$homebase/usrdirs
mkdir -p $usrdirs
rm -f $redir/usrdirs
ln -s $usrdirs $redir/usrdirs

decimals=$homebase/decimals
mkdir -p $decimals
rm -f $redir/decimals
ln -s $decimals $redir/decimals

security=$decimals/security
mkdir -p $security

all=$decimals/all
mkdir -p $all


die () { echo $@; exit 1; }
log () { echo $@;  }

[ -d "$usrnodes" ] || die "Err: no usernodes"
[ -d "$usrdirs" ] || die "Err: no usrdirs"

link_to_r () {
   local bd="$1"
   local dir="$2"

   rm -f $redir/$bd
   ln -s $dir $redir/$bd

   rm -f $all/$bd
   ln -s $dir $all/$bd
}

link_to_place () {
   local bd="$1"
   local dir="$2"
   local place="$3"

   rm -f $place/$bd
   ln -s $dir $place/$bd
}


link_decimal () {
  local bd="$1"
  local dir="$2"

  name=${bd%_*}
  dec=${bd##*_}

  local parent=$(dirname $dir)
  parentbase=$(basename $parent)
  pname=${parentbase%_*}
  pdec=${parentbase##*_}

  
  case "$pdec" in 
    6[1-9])
      link_to_dir $bd $dir $security
      link_to_r $bd $dir $redir
      ;;
    [0-9]*)
      link_to_r $bd--$pname $dir
      ;;
    *) : ;;
   esac

}


handle_decimal () {
  local bd="$1"
  local dir="$2"

   lastright=${bd##*_}
   decimal=${lastright%%.*}

   
   case "$decimal" in 
      *.*) : ;;
         [0-9][0-9]|[0-9][a-z]|[0-9][0-9].[0-9][0-9]|[0-9][0-9].-[0-9][0-9]|[0-9][a-z].[0-9][a-z]|[0-9][a-z]-[0-9][a-z])
           link_decimal "$bd" "$dir"
         ;;
      [0-9][0-9][a-z]*[0-9])
           link_decimal "$bd" "$dir"
         ;;
      [0-9][0-9][a-z]*)
           link_decimal "$bd" "$dir"
         ;;
      *) 
      echo "Omit decimal $dir"
        ;;
   esac
}


find_decimals () {
   local decdir="$1"

   find "$decdir" -type d -iname "*_[0-9]*" | while read dir ; do
      [ -d "$dir" ] || continue 
         bd=$(basename $dir)
         handle_decimal "$bd" "$dir"
   done
}

find_decimalfiles () {
   local decdir="$1"


   find "$decdir" -type f -iname "*_[0-9]*.dec*" | while read decfile ; do
      [ -f "$decfile" ] || continue 
         filebase=$(basename $decfile)
         filedir=$(dirname $decfile)
         filename=

         case "$filebase" in 
           *.decfile) 
             continue 
             ;;
           .*) filename=${filebase:1} ;;
           *)  filename=${filebase} ;;
         esac

         middleleft=${filename%_*}
         middle=${middleleft##*_}

         for dd in $filedir/* ; do
            [ -d "$dd" ] || continue
            bdd=$(basename $dd)

            # benaux-ossdev_71b1
            # benaux-ossdev_bt-ycwsscao_71b1.dec
            # left: benaux-ossdev / right: 71b1
            case "$bdd" in
              *_*)
                  left=${bdd%%_*}
                  right=${bdd##*_}
                  #right=${rightdec%%.*}
                  ;;
                *)
                  left=$bdd
                  right=
                  ;;
              esac


            case "$filename" in
             ${left}*${right}*) 
               # echo handle_decimal "$filename" "$dd"  / $left $right
               handle_decimal "$filename" "$dd" 
               # remove link if there is a dec file
               case "$bdd" in
                  *_*_*)                 
                     [ -d "$redir/${left}_${right}" ] && rm -f "$redir/${left}_${right}"
                     ;;
                   *) : ;;
                 esac
               ;;
             *) 
               echo  "log: omit decimalfile $decfile bdd:$bdd  (l:$left / r:$right)"
               :
               ;;
           esac
         done
   done
}

handle_subdir () {
  local subdir="$1"

   for d in $subdir/* ; do
      [ -d "$d" ] || continue 
      bd=$(basename $d)
      decimal=${bd##*_}
      case "$decimal" in 
         [0-9][0-9]|[0-9][a-z]|[0-9][0-9].[0-9][0-9]|[0-9][0-9]-.[0-9][0-9]|[0-9][a-z].[0-9][a-z]|[0-9][a-z]-[0-9][a-z])
            rm -f $redir/$bd
            ln -s $d $redir/$bd

             find_decimals  $d

            find_decimalfiles  $d
         ;;
         *) 
         echo "Omit: $d"
           ;;
      esac
   done
}
for node in $usrnodes/* ; do
  [ -d "$node" ] || continue 
  bnode=$(basename $node)

  case "$bnode" in 
    *.*.*)
      handle_subdir $node
      ;;
    *) 
      echo "Omit node: $node"
      ;;
  esac
done

for dir in $usrdirs/*; do
  [ -d "$dir" ] || continue 
  handle_subdir $dir
done



  
