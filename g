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
    hg files -0 | xargs -0 grep -i --color $f -- "$g"; break;;
  git)
    git ls-files -z | xargs -0 grep -i --color $f -- "$g"; break;;
  "")
    grep --color $f -ir -- "$g" *;;
esac
) 2>/dev/null
