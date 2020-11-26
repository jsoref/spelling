#!/bin/sh
g=$1
[ -z "$g" ] && exit
shift

f=$1
if [ ! -z "$f" ]; then
shift
fi

if [ -z "$F_USE_GREPR" ]; then
  if hg root >/dev/null 2>/dev/null; then
    vcs=hg
  elif git rev-parse --git-dir >/dev/null 2>/dev/null; then
    vcs=git
  fi
fi
(
case "$vcs" in
  hg)
    hg files -0 2>/dev/null | xargs -0 grep -i --color $file -- "$grep" 2>/dev/null;;
  git)
    git ls-files -z 2>/dev/null| xargs -0 grep -i --color $file -- "$grep" 2>/dev/null;;
  "")
    grep --color $file -ir -- "$grep" * 2>/dev/null;;
esac
)
