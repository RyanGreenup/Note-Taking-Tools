#!/usr/bin/env bash

## Use the current Directory because TMSU will return
## Relative Links from that directory and those
## links should work from wherever this is run

if [[ $1 != '' ]]; then
    NOTE_DIR=$1
else
    NOTE_DIR='./'
fi

command -v rg >/dev/null 2>&1 || { echo >&2 "I require ripgrep but it's not installed.  Aborting."; exit 1; }
command -v sd >/dev/null 2>&1 || { echo >&2 "I require sd (sed replacement) but it's not installed.  Aborting."; exit 1; }
command -v xclip >/dev/null 2>&1 || { echo >&2 "I require xclip but it's not installed.  Aborting."; exit 1; }
command -v tmsu >/dev/null 2>&1 || { echo >&2 "I require TMSU but it's not installed.  Aborting."; exit 1; }




ConcurrentTags=$(tmsu tags)

echo "Choose a Tag (Press any Key to Continue)"
read -d'' -s -n1 continueQ


ChosenTags=$(echo "$ConcurrentTags" | fzf -m)
MatchingFiles=$(tmsu files "$ChosenTags")

echo "

You chose the tags:

$ChosenTags

which has matches of

$MatchingFiles

"

FilterTags() {
MatchingFiles=$(tmsu files "$ChosenTags")
ConcurrentTags=$(tmsu tags $MatchingFiles | cut -f 2 -d ':' | space2NewLine | sort | uniq | sort -nr )
ChosenTags="$ChosenTags $(echo "$ConcurrentTags" | fzf)"
ChosenTags=$(echo "$ChosenTags" | sort | uniq )
MatchingFiles=$(tmsu files "$ChosenTags")

echo "
The chosen tags are

$ChosenTags

With Matching Files

$MatchingFiles

and Concurrent Tags

$ConcurrentTags

"

## read -p 'Press t to continue chosing Tags concurrently: ' conTagQ
echo "To continue filtering by tags concurrently press t

otherwise press any key to print Matches

TODO to fuzzy chose a returning file press c (fzf --preview highlight {})
"

read -d '' -n1 -s conTagQ


 if [ "$conTagQ" == "t" ]; then
     FilterTags
 fi

 echo $MatchingFiles | space2NewLine

}

space2NewLine() {
    command -v perl >/dev/null 2>&1 || { echo >&2 "I require perl but it's not installed.  Aborting."; exit 1; }
    perl -pe 's/(?<=[^\\])\ /\n/g'
}

FilterTags
exit 0





# TODO Chosen Tags Should not be listed also as concurrent Tags
# TODO Chosen Tags should all be unique
# TODO Should get an MDCat Preview
# TODO Switch from Rscript to JS [[./tags-to-TMSU.sh]]
# TODO Coloured Output
# TODO Press Any Key to continue NOT ENTER
