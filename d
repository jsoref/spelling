#!/bin/sh
# ~/bin/d
if hg root >/dev/null 2>/dev/null; then
  hg diff --git -p "$@"
elif git rev-parse --git-dir >/dev/null 2>/dev/null; then
  git diff "$@"
fi
