#!/bin/bash

command -v mdcat     >/dev/null 2>&1 || { echo >&2 "The mdcat package is a required dependency, install it with ~cargo install mdcat~"; exit 1; }
command -v sk        >/dev/null 2>&1 || { echo >&2 "The skim package is a required dependency, install it with ~cargo install skim~"; exit 1; }



if [ "$1" == "-l" ]; then
    sk --ansi -i -c 'recoll -b -t "{} ext:md" | cut -c 8-' --preview "mdcat {}" \
        --bind pgup:preview-page-up,pgdn:preview-page-down
else
    echo Enter the Search Query
    read -p 'Search: ' query
    echo searching for $query

    recoll -b -t -q "ext:md $query" | cut -c 8- | \
        fzf --bind pgup:preview-page-up,pgdn:preview-page-down --preview "mdcat {}" \
        | xargs code -a
fi
