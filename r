#!/bin/sh
# ~/bin/r "s/teh/the/" FILES
r() {
replacement="$1"
shift
while [ $# -gt 0 ]; do
  file="$1"
  shift
  [ ! -L "$f" ] &&
    perl -pi -e "$replacement" -- "$file"
done
}

if [ -z "$spelling_base_dir" ]; then
  r "$@"
fi
