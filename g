#!/bin/sh
g=$1
if [ ! -z "$g" ]; then
shift
f=$1
shift
grep --color $f -ir "$g" -- *
fi
