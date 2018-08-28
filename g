#!/bin/sh
g=$1
if [ ! -z "$g" ]; then
shift
f=$1
if [ ! -z "$f" ]; then
shift
fi
grep --color $f -ir "$g" -- *
fi
