#!/bin/sh
g=$1
[ -z "$g" ] && exit
shift

f=$1
if [ ! -z "$f" ]; then
shift
fi

(
if [ -n "$F_USE_GREPR" ] || ! hg root >/dev/null 2>/dev/null; then
  grep --color $f -ir -- "$g" *
else
  hg files -0 | xargs -0 grep -i --color $f -- "$g"
fi
) 2>/dev/null
