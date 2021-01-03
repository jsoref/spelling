#!/bin/sh
# rs old new [spelling]
# rewrite using r s/{old}/{new}/
# commit: s {spelling|new}
# currently top level hidden directories are ignored,
# this avoids accidentally scribbling over .hg/ or similar
rs() {
old=$1
new=$2
if [ "$new" = "$HOME" ]; then
  echo 'Did you accidentally run `rs '$old' ~`?'
  return 9
fi
shift
shift
if [ -z "$new" ]; then
return 1
fi
word=$1
if [ -z "$word" ]; then
word=$(echo $new|tr A-Z a-z)
fi

if [ "${new#*$old}" != "$new" ] ||
   [ "${old#*$new}" != "$old" ]; then
  old='\b'"$old"'\b'
fi

unameOut="$(uname -s)"
case "${unameOut}" in
    Darwin*) usenull=--null;;
    *)       usenull=-Z;;
esac

(
  if [ -n "$files" ]; then
    echo "$files" | tr "\n" "\0"
  elif hg root >/dev/null 2>/dev/null; then
    hg files 'set:not symlink() and ./**' -0
  elif git rev-parse --git-dir 2>/dev/null; then
    git ls-files -z
  else
    find . -mindepth 1 -maxdepth 1 -type f -name '.*' -print0
  fi
) |
  xargs -0 grep $usenull -l -i "$old" 2>/dev/null |
  xargs -0 -I '<>' r "s{$old}{$new}g" "<>"
s "$word"
#$(echo $new|tr A-Z a-z)
}

if [ -z "$spelling_base_dir" ]; then
  rs "$@"
fi
