#!/bin/sh
r=$1
shift
perl -pi -e "$r" "$@"
