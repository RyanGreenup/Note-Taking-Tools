#!/usr/bin/env bash
# set -euo pipefail
NOTESDIR="$HOME/Notes/MD/notes"

cd $NOTESDIR

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

FilterTags() {
MatchingFiles=$(tmsu files "$ChosenTags")
ConcurrentTags=$(tmsu tags $MatchingFiles | cut -f 2 -d ':' | perl -pe 's/(?<=[^\\])\ /\n/g' | sort | uniq | sort -nr )
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

read -d'' -s -n1 conTagQ


 if [ "$conTagQ" == "t" ]; then
     FilterTags
 else
     echo "No Longer Filtering Tags"
     return
 fi

 echo $MatchingFiles

}

FilterTags
exit 0
