#!/bin/sh
# ~/bin/r "s/teh/the/" FILES
r=$1
shift
perl -pi -e "$r" -- "$@"
