#! /bin/bash

set -euo pipefail

CC=cc

build() {
        local dir=$1
        local lang=$2
        local dest=$3

        cp "$dir/grammar.js" "$dir/src"
        pushd "$dir/src" >/dev/null

        $CC -fPIC -c -I. parser.c

        if [ -f scanner.c ]; then
                $CC -fPIC -c -I. scanner.c
        elif [ -f scanner.cc ]; then
                CC=c++
                $CC -fPIC -I. -c scanner.cc
        fi

        $CC -fPIC -shared ./*.o -o "$dest/libtree-sitter-${lang}.dll"
        rm -f grammar.js ./*.o
        popd >/dev/null
}

dir=$1
if [ "$dir" = . ]; then
        lang=$(pwd)
        lang=${lang##*/}
else
        lang=$dir
fi

echo -n "Building $lang... "

if [ "$lang" = typescript ]; then
        dest=../../../dist
        build "$dir/typescript" typescript "$dest"
        build "$dir/tsx" tsx "$dest"
else
        dest=../../dist
        build "$dir" "$lang" "$dest"
fi

if [ "$dir" = . ]; then
        cp "$dir/LICENSE" "../dist/licenses/LICENSE-$lang"
else
        cp "$dir/LICENSE" "dist/licenses/LICENSE-$lang"
fi

echo "done."
