#!/bin/bash

command -v mdcat     >/dev/null 2>&1 || { echo >&2 "The mdcat package is a required dependency, install it with ~cargo install mdcat~"; exit 1; }
command -v sk        >/dev/null 2>&1 || { echo >&2 "The skim package is a required dependency, install it with ~cargo install skim~"; exit 1; }



sk --ansi -i -c 'rg --color=always -l "{}"' --preview "mdcat {}" \
        --bind pgup:preview-page-up,pgdn:preview-page-down 

