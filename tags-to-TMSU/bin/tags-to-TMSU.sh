#!/usr/bin/env bash
set -euo pipefail

if [ -z "$1" ]; then
    NOTE_DIR=$1
else
    NOTE_DIR='./'
fi

echo 'Which Type of tags would you like to import to TMSU create (1/2/3)?

y ::  YAML Tags
t ::  #Tags
b ::  Both
h ::  help
'

read -p 'Selection (y/t/b): ' choice


if [ $choice == 'y' ]; then
    echo "Option $choice selected" #FIXME
    RScript ./bin/YamltoTMSU.R $NOTE_DIR
    cat /tmp/00tags.csv | bash
elif [ $choice == 't' ]; then
    echo "Option $choice selected" #FIXME
  ./bin/hashtags.sh $NOTE_DIR | bash
elif [ $choice == 'b' ]; then
    echo "Option $choice selected" #FIXME
    ## Implement HashTags
    ./bin/hashtags.sh $NOTE_DIR| bash

    ## Implement YAML Tags
    RScript ./bin/YamltoTMSU.R $NOTE_DIR
    cat /tmp/00tags.csv | bash
elif [ $choice == 'h' ]; then
    echo "To use this script pipe the output back to bash"
else
    echo 'Please enter y/t/b'
fi
