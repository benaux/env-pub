#!/bin/sh

inputfile="$1"
cwd="$2"


die () { echo "$@"; exit 1; }

[ -n "$inputfile" ]  && {
  [ -f "$inputfile" ] || { echo "Err: invalid file"; exit 1; }
}

inputdir=$(dirname "$inputfile")
inputbase=$(basename "$inputfile")

#$tmux has-session -t "out" || die "Err: no session 'out'"

cwd_base=$(basename $cwd)
cwd_base_tmux=${cwd_base%.*}
do_tmux () {
  tmux send-keys -t "$cwd_base_tmux" "$@" Enter

  #tmux has-session -t "log" && tmux send-keys -t "log" "echo '$@'" Enter
}

if [ -f "$cwd/vif.sh" ] ; then
  sh ./vif.sh '$inputfile'
elif [ -f "$cwd/Makefile.dev" ] ; then
  do_tmux "clear && make -f Makefile.dev vif" 
elif [ -f "$cwd/Makefile.vi" ] ; then
  do_tmux "clear && make vif" 
elif [ -f "$cwd/Makefile" ] ; then
  do_tmux "clear && make -f Makefile vif" 
elif [ -f "$inputfile" ] ; then
   inputname=${Inputbase%.*}
   inputext=${inputbase##*.}

    cmd=
    case "$inputext" in
      pl) cmd="perl $inputfile";;
      sh) cmd="sh $inputfile";;
      bash) cmd="bash $inputfile";;
      ml) cmd="ocamlc -o $inputname $inputfile && ./$inputname";;
      c) cmd="gcc -o $inputname $inputfile && ./$inputname";;
      py) cmd="python $inputfile";;
      d) cmd="rdmd $inputfile";;
      *) : ;;
    esac

    if [ -n "$cmd" ] ; then
      do_tmux "cd $inputdir && ${cmd}"
    else
      do_tmux "cd $inputdir && clear && echo 'Err: no vif.sh file and no command...'" Enter
    fi
  else
    echo "usage: Makefile | vif.sh | inputfile.pl"
fi

