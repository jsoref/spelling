#!/bin/sh
word=$1
shift
hg commit -m "spelling: $word" $@
