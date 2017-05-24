#!/bin/sh
# ~/bin/f
# Run ~/bin/w [find possibly misspelled words] on argument or current directory items (excluding hidden items)
# This could be switched to include hidden items...
if [ -n "$1" ]; then
  where="$1"
else
  where="*"
  # .[!.]*
fi
DIR=`echo "
.bzr
.git
.hg
.svn
CVS
node_modules
"|xargs -n1 echo`
EXT=`echo "
bmp
bz2
dll
dylib
exe
gz
ico
jar
jpg
otf
eot
ttf
woff
png
po
pyc
rpm
so
svg
xpm
zip
"|xargs -n1 echo`
Q="'"
D1='$1'
pDIR=`echo $DIR|perl -pne "s/(\\S+)/-name $D1 -prune -o /g"`
pEXT=`echo $EXT|perl -pne "s/(\\S+)/-iname $Q*.$D1$Q -prune -o /g"`
find $where $pDIR $pEXT  -type f -print0 | xargs -0 ~/bin/w | ~/bin/w 2>/dev/null
