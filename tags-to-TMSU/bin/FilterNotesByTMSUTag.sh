#!/usr/bin/env bash

## Use the current Directory because TMSU will return
## Relative Links from that directory and those
## links should work from wherever this is run

DEFAULTAPP=code ## TODO Should this be xdg-open?

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
TEMPDIR=/tmp/00tagMatches
echo -e "


⁍ \e[1;35mt\e[0m      :: Choose Concurrent \e[1;35mT\e[0mags
⁍ AnyKey :: Accept Chosen Tags \e[1;35mT\e[0mags
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

rm -r $TEMPDIR ## If you want to have or logic for tags, the selections
                  ## must persist over iterations
mkdir $TEMPDIR 2>/dev/null


for i in $MatchingFiles; do
    ln -s $(realpath $i) /tmp/00tagMatches 2>/dev/null
done
echo "SymLinks Made in $TEMPDIR"

echo -e "
⁍ \e[1;35mv\e[0m      :: Open all matching files with \e[1;35mV\e[0mSCode
⁍ \e[1;35mc\e[0m      :: \e[1;35mC\e[0mhoose a file to open
⁍ AnyKey :: Create Symlinks in $TEMPDIR
"


read -d '' -n1 -s openQ

 if [ "$openQ" == "c" ]; then
     cd $TEMPDIR
     ## sk --ansi -i -c 'rg --color=always -l "{}"' --preview "mdcat {}" \
     ##        --bind pgup:preview-page-up,pgdn:preview-page-down
     sk --ansi --preview "mdcat {}" \
         --bind pgup:preview-page-up,pgdn:preview-page-down | \
         xargs realpath | xargs $DEFAULTAPP -a
 elif [ "$openQ" == "v" ]; then

     for i in "$MatchingFiles"; do

         code -a $i

     done

 else
     echo ''
 fi

exit 0





# DONE Chosen Tags Should not be listed also as concurrent Tags
# DONE Should get an MDCat Preview
  # DONE Should get Bullets and Horizontal Rules
# DONE Initial Tag
# DONE Coloured Output
# TODO Output should be useful
# DONE fif should use `rg --follow` by default
    # TODO fimd should use mdcat by default
    # TODO Empty fif argument should search for anythin.
    # TODO Nah maybe a Skim Interactive mode would be better?
# TODO Should not call code when C-c out
# TODO Should Cleare Symlink Folder after Running
# TODO Should the option to regen tags present itself?
