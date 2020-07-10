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

echo "
To begin Tag Selection press any key"
read -d '' -s -n1 continueQ

FilterTags() {
ChosenTags="$ChosenTags $(echo "$ConcurrentTags" | fzf)"
MatchingFiles=$(tmsu files "$ChosenTags")
ConcurrentTags=$(tmsu tags $MatchingFiles | cut -f 2 -d ':' | space2NewLine | sort | uniq | sort -nr )
ChosenTags=$(echo "$ChosenTags" | space2NewLine | sort -u )
ConcurrentTags=$(comm -13 <(echo "$ChosenTags" | sort) <(echo "$ConcurrentTags" | sort))


echo -e "

\e[1;32m
═══════════════════════════════════════════════════════════════════════════
\e[0m

The chosen tags are:

\e[1;35m
$(addBullets "$ChosenTags")
\e[0m

With Matching Files:

\e[1;34m
$(addBullets "$MatchingFiles")
\e[0m

and Concurrent Tags:
\e[1;33m
$(addBullets "$ConcurrentTags")
\e[0m
\e[1;32m
═══════════════════════════════════════════════════════════════════════════
\e[0m
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

}

space2NewLine() {
    command -v perl >/dev/null 2>&1 || { echo >&2 "I require perl but it's not installed.  Aborting."; exit 1; }
    perl -pe 's/(?<=[^\\])\ /\n/g' | rmLeadingWS
}

## For some reason the first TagResult has a leading whitespace which causes it to double up
## This function strips whitespace and so needs to be used
rmLeadingWS() {
    command -v sd >/dev/null 2>&1 || { echo >&2 "I require sd (sed replacement) but it's not installed.  Aborting."; exit 1; }
    sd '^ ' ''
}

addBullets() {
    echo "$1" | perl -pe 's/^(?=.)/\tʘ\ /g'
}


FilterTags

echo "$MatchingFiles"
exit 0





# DONE Chosen Tags Should not be listed also as concurrent Tags
# DONE Should get an MDCat Preview
  # DONE Should get Bullets and Horizontal Rules
# DONE Initial Tag
# DONE Coloured Output
# TODO Output should be useful
