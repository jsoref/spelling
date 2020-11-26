#!/bin/sh
word=$1
shift
if hg root >/dev/null 2>/dev/null; then
  hg commit -m "spelling: $word" $@
elif git rev-parse --git-dir >/dev/null 2>/dev/null; then
  (git add ${@:-$(git ls-files -m)} && git commit -m "spelling: $word" $@)
fi
