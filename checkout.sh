#! /bin/bash

set -eo pipefail

git fetch
git switch -d origin/HEAD

cp ../gitattributes-hack .gitattributes
git status
git restore .gitattributes
git status
