HELP='Gambit Scheme compiler that compiles to different backends'
USAGE='[-l lib|--lib=] <lang> <file>'

die () { echo $*; exit 1; }
usage () { die "usage - " $(basename $0) ": $USAGE" ; }

[ "$#" -eq 0 ] && usage 

lib=
while [ "$#" -gt 0 ] ; do
  case "$1" in
    --lib=*)
      lib=${1##*=}
      ;;
    -l)
      lib=$2
      shift
      ;;
    -*)
      usage
      ;;
  esac
  shift
done

echo $lib
exit

GSC=../gsc/gsc -:=.. -target js
GSC=gsc -target js

all: run


lib.js: lib.scm
	$(GSC) -c lib.scm

app.js: app.scm
	$(GSC) -c app.scm

app_.js: lib.js app.js
	$(GSC) -link -l lib app.js

linked_app.js: lib.js app.js app_.js
	$(GSC) -c lib.scm
	cat app_.js lib.js app.js > linked_app.js
	wc *.js

run: linked_app.js
	node linked_app.js

clean:
	rm -f lib.js app.js app_.js linked_app.js
	rm -f *.html

doc: 
	pandoc -s Article.txt > Article.html
