#! /bin/bash

set -eo pipefail

check_changed() {
        mods=$(git status --porcelain | awk '/^ M/ { if (mods == "") { mods=$2 } else { mods=mods "," $2 } } END { print mods }')
        if [ -n "$mods" ]; then
                echo modules="$mods"
                return 0
        else
                return 1
        fi
}

git submodule foreach bash ../checkout.sh

echo "!$GITHUB_OUTPUT!"

if [ -n "$GITHUB_OUTPUT" ]; then
        if check_changed >> "$GITHUB_OUTPUT"; then
                date +%Y%m%d > tag.txt
                git submodule status > language-manifest.txt
        fi
else
        check_changed
fi
