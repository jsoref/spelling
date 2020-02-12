## Workflows

1. [Short](#Short)
1. [Detailed](#Detailed)
1. [Dev](#Dev)

### Short

* Browse output of `f` in one window (word list).
* Have a Terminal ready for commits (edit stream).
*  Have a window for getting spelling corrections (Browser URL bar)

1. Start with the word list.
1. Copy a token (`acecss`).
1. Switch to edit stream terminal.
1. `g `(paste)`acecss`↵
1. `rs acecss  ` (including a trailing space).
1. Switch to web browser (focussing URL Bar or a text editor).
1. (paste)`acecss`
1. Get suggested corrected spelling (e.g. down arrow).
1. Copy
1. Switch back to edit stream terminal.
1. Paste:
  `rs acecss access` ↵
1. Switch back to tokenlist window and repeat process.

### Detailed

I tend to do:

```sh
hg clone git@github.com:jsoref/spelling.git
# get a repository to work on
cd spelling
hg bookmark ignore
# exclude content that shouldn't be spellchecked
hg rm vendor ...
# upstream content
hgrmjunk
# various file types including pictures
hgfilesample
hg rm `hg locate '*.dmg'` ...
# binary content
hg commit -m ignore
hg bookmark spelling
# mark our work
f > ../spelling.txt
# build token list
less ../spelling.txt &
# start looking at the list
ge absolut # because `g absolut` would find `absolute`
# look for a whole misspelled word
rs 'absolut ' 'absolute ' absolute
# correct it
g Actualy
# look for substring
rs Actualy Actually
# correct it
g addess
# look for substring
rs addess address
rs Addess Address
rs ADDESS ADDRESS
# correct each variant
EDITOR=hesort hg histedit ignore
# collapse the fixes
...
# JavaScirpt
g Scirpt
rs Scirpt Script
# JaveScript
g Jave
rs Jave Java
g Javascript
r s/Javascript/JavaScript/g $(g Javascript -l)
b JavaScript
# tag branding fix differently (it will sort elsewhere)
...
ge thi
r 's/thi s/this /g' $(ge thi|gl)
d
# verify the change didn't mess something else up
s this
# commit
...
hg rebase -r 'spelling % ignore' -d master
# exclude the ignore commit(s) and return to master
```

### Dev

If you're reviewing patches:

```sh
fchurn repository
patch -d repository -p1 < proposed-commit
fchurn repository
```

If you're trying to catch typos before you commit:

```sh
fchurn repository
pushd repository
# make changes
...
popd
fchurn repository
```
