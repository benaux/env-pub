#!/bin/sh


declink=$1

[ -f "$declink" ]  || { echo "usage decklink.txt file" ; exit 1;  }

declinktitle=${declink%.*}

declinktxt=$(head -n 1 $declink)

declinkbase=$(basename $declink)
declinkdir=$(dirname $declink)

declinkname=${declinkbase%.*}
declinkhtml=$declinkdir/$declinkname.html

{
echo '<!DOCTYPE html>'
echo '<html xmlns="http://www.w3.org/1999/xhtml" lang="" xml:lang="">'
echo '<head>'
echo '  <meta charset="utf-8" />'
echo "<title>$declinktitle</title>"
echo "<meta http-equiv='refresh' content='0; url=$declinktxt' />" 
echo '</head>'
echo '<body>'
echo "<p><a href='$declinktxt'>$declinktxt</a></p>"
echo '</body>'
echo '</html>'
} > $declinkhtml
