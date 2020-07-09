#!/usr/bin/env bash
# set -euo pipefail

command -v rg >/dev/null 2>&1 || { echo >&2 "I require ripgrep but it's not installed.  Aborting."; exit 1; }
command -v sd >/dev/null 2>&1 || { echo >&2 "I require sd (sed replacement) but it's not installed.  Aborting."; exit 1; }
command -v xclip >/dev/null 2>&1 || { echo >&2 "I require xclip but it's not installed.  Aborting."; exit 1; }
command -v tmsu >/dev/null 2>&1 || { echo >&2 "I require TMSU but it's not installed.  Aborting."; exit 1; }
command -v perl >/dev/null 2>&1 || { echo >&2 "I require perl but it's not installed.  Aborting."; exit 1; }


ConcurrentTags=$(tmsu tags)

echo "Choose a Tag"
read -p 'Press Any Key to Continue: ' ConQ


ChosenTags=$(echo "$ConcurrentTags" | fzf -m)
MatchingFiles=$(tmsu files "$ChosenTags")

echo "

You chose the tags:

$ChosenTags

which has matches of

$MatchingFiles

"

echo "Choose a Tag"
read -p 'Press Any Key to Continue: ' ConQ

## Converting non-escaped-space with new line requires look behind,
  ## this requires `perl -pe` or two replacements with `sd`
ConcurrentTags=$(tmsu tags $MatchingFiles | cut -f 2 -d ':' | perl -pe 's/(?<=[^\\])\ /\n/g' | sort | uniq | sort -nr )
## ConcurrentTags=$(tmsu tags $MatchingFiles | cut -f 2 -d ':' | | sd -s '\ ' '###' | sd ' ' '\n' | sd '###' ' ' | sort | uniq | sort -nr )

ConcurrentTagsPrintTable=$(tmsu tags $MatchingFiles | cut -f 2 -d ':' | rg --pcre2  '(?<=[^\\]) ' -r '
' | sort | uniq -c | sort -nr)



echo "

The concurrent tags are:

$ConcurrentTags


"

echo 'Would you like to Narrow down more or Choose a file?

t ::  Choose more Tags
f ::  Choose a File
p ::  Print Matching Paths

Make sure to run this from inside the notes directory

(and to back them up of course!)
'

read -p 'Selection (y/t/b): ' choice


if [ $choice == 't' ]; then
    echo "Option $choice selected"

    ## Make a File in /tmp/00tags.sh listing the tmsu commands to run
    Rscript ~/bin/YamltoTMSU.R $NOTE_DIR ## Assumption that RScript is in ~/bin

    ## Change into the notes dir and run those commands
    cd $NOTE_DIR
    bash /tmp/00tags.sh

elif [ $choice == 'f' ]; then
    echo "Option $choice selected" #FIXME

    ## Print the TMSU commands to run to STDOUT (including a CD)
    ## Pipe these back to bash
    hashtags.sh $NOTE_DIR | bash  ## Assumption that hashtags.sh is in PATH
elif [ $choice == 'p' ]; then
    echo "Option $choice selected" #FIXME
    ## TODO this should maybe loop back around ?
    ## I should restructure this with functions anyway.

    ## Implement HashTags
    hashtags.sh $NOTE_DIR | bash  ## Assumption that hashtags.sh is in PATH

    ## Implement YAML Tags
    Rscript ~/bin/YamltoTMSU.R $NOTE_DIR ## Assumption that RScript is in ~/bin

    cd $NOTE_DIR
    bash /tmp/00tags.sh
elif [ $choice == 'n' ]; then
    echo "Option $choice selected" #FIXME
    cd $NOTE_DIR
    tmsu init
else
    echo 'Please enter t/f/p'
    exit 0
fi

## Now I need to filter down the tags.


exit 0
