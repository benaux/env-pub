#!/bin/sh


cwd=$(pwd)
what=$(basename $cwd)

title=${what%-*}

echo '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
echo '<html xmlns="http://www.w3.org/1999/xhtml">'
echo '<head>'
echo '  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'
echo "  <title>$title</title>"
echo '  </head>'
echo '  <body>'
echo "  <h1>$title</h1>"

echo "  <dl>"

for d in *; do
      #if [ -d "$d" ]; then
         echo "    <dt><a href='$d'>$d</a></dt>"
         echo "    <dd> </dd>"
done

echo "  </dl>"


echo '  </body>'
echo '  </html>'
