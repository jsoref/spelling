#!/bin/sh
g() {
grep=$1
[ -z "$grep" ] && return
shift

file=$1
if [ ! -z "$file" ]; then
shift
fi

if [ -z "$F_USE_GREPR" ]; then
  if [ -n "$files" ]; then
    vcs=files
  elif hg root >/dev/null 2>/dev/null; then
    vcs=hg
  elif git rev-parse --git-dir >/dev/null 2>/dev/null; then
    vcs=git
  fi
fi
(
case "$vcs" in
  files)
    echo "$files" | tr "\n" "\0" | xargs -0 grep -i --color $file -- "$grep" 2>/dev/null;;
  hg)
    hg files -0 2>/dev/null | xargs -0 grep -i --color $file -- "$grep" 2>/dev/null;;
  git)
    git ls-files -z 2>/dev/null| xargs -0 grep -i --color $file -- "$grep" 2>/dev/null;;
  "")
    grep --color $file -ir -- "$grep" * 2>/dev/null;;
esac
)
}

if [ -z "$spelling_base_dir" ]; then
  g "$@"
fi
