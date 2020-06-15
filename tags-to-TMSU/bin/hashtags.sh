#!/usr/bin/env bash
set -euo pipefail

if [ -z "$1" ]; then
    NOTE_DIR=$1
else
    NOTE_DIR='./'
fi

rg --pcre2 '(?<=\s#)[a-zA-Z]+(?=\s)' -t markdown -o \
        | sed s+:+\ + | sed s/^/tmsu\ tag\ / $NOTE_DIR
