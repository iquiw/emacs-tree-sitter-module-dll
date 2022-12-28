#! /bin/sh

set -euo pipefail

dir=$1
if [ "$dir" = . ]; then
        lang=$(pwd)
        lang=${lang##*/}
else
        lang=$dir
fi

echo -n "Building $lang... "

cp "$dir/grammar.js" "$dir/src"
cd "$dir/src"

CC=cc

$CC -fPIC -c -I. parser.c

if [ -f scanner.c ]; then
	$CC -fPIC -c -I. scanner.c
elif [ -f scanner.cc ]; then
	CC=c++
	$CC -fPIC -I. -c scanner.cc
fi

$CC -fPIC -shared *.o -o "../../dist/libtree-sitter-${lang}.dll"

cp ../LICENSE "../../dist/licenses/LICENSE-$lang"

echo "done."
