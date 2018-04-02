#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

CC="clang-6.0"
CXX="clang++-6.0"
CFLAGS="-fsanitize=fuzzer"
CXXFLAGS="$CFLAGS"
FUZZ_DIR="Modules/_xxtestfuzz"
OUT="."

for fuzz_test in $(cat $FUZZ_DIR/fuzz_tests.txt)
do
    $CC $CFLAGS \
        -D _Py_FUZZ_ONE -D _Py_FUZZ_$fuzz_test \
        -Wno-unused-function $(./p/bin/python3-config --cflags) \
        -c -g -O1 \
        $FUZZ_DIR/fuzzer.c -o $fuzz_test.o
    $CXX $CXXFLAGS \
        $fuzz_test.o -o $OUT/$fuzz_test \
        $(./p/bin/python3-config --ldflags)
done
