#! /bin/sh

set -euo pipefail

dir=$1

mkdir -p dist

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

$CC -fPIC -shared *.o -o "../../dist/libtree-sitter-${dir}.dll"

