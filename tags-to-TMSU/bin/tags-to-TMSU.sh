#!/usr/bin/env bash

if [[ $1 != '' ]]; then
    NOTE_DIR=$1
else
    NOTE_DIR='./'
fi

echo 'Which Type of tags would you like to import to TMSU create (1/2/3)?

n ::  New TMSU DB
y ::  YAML Tags
t ::  #Tags
b ::  Both    (Requires R-TidyVerse and R-rmarkdown #TODO switch to JS)
x ::  Clear all TMSU DB
h ::  help

Make sure to run this from inside the notes directory

(and to back them up of course!)
'

read -p 'Selection (y/t/b): ' choice


if [ $choice == 'y' ]; then
    echo "Option $choice selected"

    ## Make a File in /tmp/00tags.sh listing the tmsu commands to run
    Rscript ~/bin/YamltoTMSU.R $NOTE_DIR ## Assumption that RScript is in ~/bin

    ## Change into the notes dir and run those commands
    cd $NOTE_DIR
    bash /tmp/00tags.sh

elif [ $choice == 't' ]; then
    echo "Option $choice selected" #FIXME

    ## Print the TMSU commands to run to STDOUT (including a CD)
    ## Pipe these back to bash
    hashtags.sh $NOTE_DIR | bash  ## Assumption that hashtags.sh is in PATH
elif [ $choice == 'b' ]; then
    echo "Option $choice selected" #FIXME
    ## TODO this should maybe loop back around ?
    ## I should restructure this with functions anyway.

    ## Implement HashTags
    hashtags.sh $NOTE_DIR | bash  ## Assumption that hashtags.sh is in PATH

    ## Implement YAML Tags
    Rscript ~/bin/YamltoTMSU.R $NOTE_DIR ## Assumption that RScript is in ~/bin
                                         ## Should this use R or JavaScript??

    cd $NOTE_DIR
    bash /tmp/00tags.sh
elif [ $choice == 'n' ]; then
    echo "Option $choice selected" #FIXME
    cd $NOTE_DIR
    tmsu init
elif [ $choice == 'x' ]; then
    echo 'Attempting to Remove TMSU DB
                                      '

    cd $NOTE_DIR

    if [ -d .tmsu  ]; then
     rm -r .tmsu
     tmsu init
    echo "TMSU Database Reset"
    else
      echo "No Database Found, Make one with option n
                              "
    fi



elif [ $choice == 'h' ]; then
    echo "To use this script pipe the output back to bash"
else
    echo 'Please enter y/t/b'
    exit 0
fi


exit 0
