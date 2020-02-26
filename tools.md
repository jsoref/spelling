# Spelling tools

## Path Overview

These tools are designed to live in `~/bin`, I haven't spent the time to have
them fish for their own locations. I'm not a huge fan of `bash` and would rather
use either portable `sh` or `perl`.

They're built on top of `hg`, but you could probably make an `hg`
script / symlink that runs `git` w/ minimal effort.

## Tools

### f

- Finds potentially misspelled words in a repository/directory:
  * `f repository`
- Runs `w` on files (excludes repositories / certain file types)

### fchurn

- Find newly misspelled words in a repository since the last run:
  * `fchurn repository`

### dchurn

- Find newly misspelled words in a diff:
  * `d|dchurn`

### rediff

- Find word changes from a diff:
  * `d -U0 -c.|rediff`

### w

- Generate a list of tokens that might be misspelled
- You will need to feed this to another tool (`Google Suggest`, `MS Word`, ..., or
  your head) to decide what's actually a misspelling

### g

- Find instances of token in corpus (including as substrings of other words):
  * `g woord`

### ge

- Find instances of word in corpus (this excludes substring word matches):
  * `ge exclu`

### gl

- Extract filenames from file prefixed grep output:
  * `g 'something' | gl` ~ `grep -ilr something . `

### rs

- Replace and commit spelling fix:
  * `rs teh the` ~ `r 's{teh}{the}' $(g teh -l); s the`
  * `rs 'thi s' 'this ' this` ~ `r 's{thi s}{this }' $(g 'thi s' -l); s this`

### r

- Run replace token with correction on FILES:
  * `r s/woord/word/ FILES`

### s

- Commit a spelling fix:
  * `s word`

### b

- Commit a brand fix:
  * `b JavaScript`

### d

- Diff:
  * `d -U0 -c.`

### dn

- Select only new lines from diff output:
  * `d | dn | w`

### hesort

- Sort spelling commits:
  * `EDITOR=hesort hg histedit ignore`
  * `EDITOR=hesort hg histedit -r 'spelling % ignore'`

### chore-spelling

- Prefix spelling: commits with chore:
  * `chore-spelling 'spelling % master'`

### signed-off-by

- Add 'signed-off-by: user@address':
  * `SIGNED_OFF_BY="Signed-off-by: user <user@example.com>" signed-off-by 'spelling % master'`

### splitter

- Convert patches (standard input or arguments) into numbered patch files

### hgfileexts

- Report file extensions in repository

### hgfilesample

- Run `less` with one file for each file type from `hgfileexts`
- Use this to identify binary file types to be excluded

### hgmv

- Rename files:
  * `hgmv Javascript JavaScript`

### hgrmjunk

- Delete files that should not be spellchecked

### convertpatch-to

- Convert existing Mercurial commits into other commands
- this is mostly used for transplanting or replaying a common set of replacements against another repository:

    ```
    # working directory is terraform-provider-google
    # sibling directory is magic-modules
    # Input is a sequence of commits here:
    #   https://github.com/terraform-providers/terraform-provider-google/pull/4235
    # Output is a sequence of commits here:
    #   https://github.com/GoogleCloudPlatform/magic-modules/pull/2183
    # This gets a list of commits (in ascending order) on the spelling branch starting past the master commit
    for a in $(hg log -T '{rev} ' -r spelling%master); do
      # this line calls convertpatch-to and asks for an `rs` command
      X="$(MODE=rs convertpatch-to -c$a)";
      (
        cd ../magic-modules/;
        # this line runs that command in the magic-modules directory
        sh -c "$X"
      ) 2>&1
    done |perl -ne 'next if /^Required ruby|^To install do/;print'
    # the last perl is because `magic-modules/.ruby-version` triggers annoying warnings that I don't care about
    ```

### wdiff

- Compare misspellings in two files:
  * `wdiff file.orig file`

### wreview

- See potentially misspelled words highlighted from each file:
  * `wreview FILE`

## Prerequisites

See [prerequisites](prerequisites.md)
