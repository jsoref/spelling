#!/bin/sh
# rs old new [spelling]
# rewrite using r s/{old}/{new}/
# commit: s {spelling|new}
# currently top level hidden directories are ignored,
# this avoids accidentally scribbling over .hg/ or similar
old=$1
new=$2
shift
shift
if [ -z "$new" ]; then
exit 1
fi
word=$1
if [ -z "$word" ]; then
word=$(echo $new|tr A-Z a-z)
fi

unameOut="$(uname -s)"
case "${unameOut}" in
    Darwin*) usenull=--null;;
    *)       usenull=-Z;;
esac

grep $usenull -l -ir "$old" `find . -mindepth 1 -maxdepth 1 -type f -name '.*'` * |xargs -0 -I '<>' ~/bin/r "s{$old}{$new}g" "<>"
~/bin/s "$word"
#$(echo $new|tr A-Z a-z)
