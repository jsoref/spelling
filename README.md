# Spelling tools

## Overview

Everyone makes typos. This includes people writing documentation and comments,
but it also includes programmers naming variables, functions, apis, classes,
and filenames.

Often, programmers will use `InitialCapitalization`, `camelCase`,
`ALL_CAPS`, or `IDLCase` when naming their things. When they do this, it makes
it much harder for naive spelling tools to recognize misspellings, and as such,
with a really high false-positive rate, people don't tend to enable spellchecking
at all.

This repository's tools are capable of tolerating all of those variations.
Specifically, `w` understands enough about how programmers name things that it
can split the above conventions into word-like things for checking against a
dictionary.

See [workflows](workflows.md) for how these tools are usually used
together.
See [tools](tools.md) for a description of each tool and sample usage.

## Path Overview
These tools are designed to live in `~/bin`, I haven't spent the time to have
them fish for their own locations. I'm not a huge fan of `bash` and would rather
use either portable `sh` or `perl`.

They're built on top of `hg`, but you could probably make an `hg`
script / symlink that runs `git` w/ minimal effort.

## Prerequisites

See [prerequisites](prerequisites.md)

## CI Integration
It is possible to integrate this with your favorite CI. I'm slowly working on this.
My initial work was done for the [checkstyle](https://github.com/checkstyle/checkstyle/) project.
See the [Travis hook](https://github.com/checkstyle/checkstyle/blob/master/.ci/test-spelling-unknown-words.sh).

## License

MIT
