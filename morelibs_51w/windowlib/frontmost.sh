

die () { echo $@ 1>&2 ; exit 1; }

os=
if [ -n  "$1"  ] ; then
  os="$1"
else
  os=$(uname)
fi

case "$os" in
  Darwin)
   osascript -e 'tell application "System Events" to get name of  first application process whose frontmost is true'
   ;;
 *)
   die "Err: todo os $os"
   ;;
esac

