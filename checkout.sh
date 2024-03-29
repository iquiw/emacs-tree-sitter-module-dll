#! /bin/bash

set -eo pipefail

git fetch
git switch -d origin/HEAD

if [ -f .gitattributes ]; then
	cp ../gitattributes-hack .gitattributes
	git status
	git restore .gitattributes
fi
git status
