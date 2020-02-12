#!/bin/sh
# rs old new [spelling]
# rewrite using r s/{old}/{new}/
# commit: s {spelling|new}
# currently top level hidden directories are ignored,
# this avoids accidentally scribbling over .hg/ or similar
old=$1
new=$2
if [ "$new" = "$HOME" ]; then
  echo 'Did you accidentally run `rs '$old' ~`?'
  exit 9
fi
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

(hg root >/dev/null &&
  hg files 'set:not symlink() and ./**' -0 ||
  find . -mindepth 1 -maxdepth 1 -type f -name '.*' -print0
) |
  xargs -0 grep $usenull -l -i "$old" |
  xargs -0 -I '<>' ~/bin/r "s{$old}{$new}g" "<>"
~/bin/s "$word"
#$(echo $new|tr A-Z a-z)
