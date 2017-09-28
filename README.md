# Spelling tools

## Overview
These tools are designed to live in `~/bin`, I haven't spent the time to have
them fish for their own locations. I'm not a huge fan of `bash` and would rather
use either portable `sh` or `perl`.

They're built on top of `hg`, but you could probably make an `hg`
script / symlink that runs `git` w/ minimal effort.

## Tools

f:
- Finds potentially misspelled words in a repository/directory:
  `f repository`
- Runs `w` on files (excludes repositories / certain file types)

fchurn:
- Find newly misspelled words in a repository since the last run:
  `fchurn repository`

dchurn:
- Find newly misspelled words in a diff:
  `d|dchurn`

rediff:
- Find word changes from a diff:
  `d -U0 -c.|rediff`

w:
- Generate a list of tokens that might be misspelled
- You will need to feed this to another tool (`Google Suggest`, `MS Word`, ..., or
  your head) to decide what's actually a misspelling

g:
- Find instances of token in corpus (including as substrings of other words)
  `g woord`

ge:
- Find instances of word in corpus (this excludes substring word matches)
  `ge exclu`

gl:
- `g 'something' | gl` ~ `grep -ilr something . `

rs:
- Replace and commit spelling fix:
  `rs teh the` ~ `r teh the; s the`
  `rs 'thi s' 'this ' this` ~ `r 'thi s' 'this '; s this`

r:
- Replace token with correction:
  `r woord word`

s:
- Commit a spelling fix:
  `s word`

b:
- Commit a brand fix:
  `b JavaScript`

d:
- Diff:
  `d -U0 -c.`

dn:
- Select only new lines from diff output:
  `d | dn | w`

hesort:
- Sort spelling commits:
  `EDITOR=hesort hg histedit ignore`
  `EDITOR=hesort hg histedit -r 'spelling % ignore'`

hgfileexts:
- Report file extensions in repository

hgfilesample:
- Run `less` with one file for each file type from `hgfileexts`
- Use this to identify binary file types to be excluded

## Prerequisites
* find
* grep
* hg
* less
* perl
* sh
* sort
* uniq
* xargs

## Short workflow

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

## Detailed workflow

I tend to do:
```sh
hg clone git@github.com:jsoref/spelling.git
# get a repository to work on
cd spelling
hg bookmark ignore
# exclude content that shouldn't be spellchecked
hg rm vendor ...
# upstream content
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
r Javascript JavaScript 
b JavaScript
# tag branding fix differently (it will sort elsewhere)
...
ge thi
r 'thi s' 'this '
d
# verify the change didn't mess something else up
s this
# commit
...
hg rebase -r 'spelling % ignore' -d master
# exclude the ignore commit(s) and return to master
```

## Dev workflow
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

## License
    
MIT
