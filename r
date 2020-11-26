#!/bin/sh
# ~/bin/r "s/teh/the/" FILES
r="$1"
shift
while [ $# -gt 0 ]; do
  f="$1"
  shift
  [ ! -L "$f" ] &&
    perl -pi -e "$r" -- "$f"
done
