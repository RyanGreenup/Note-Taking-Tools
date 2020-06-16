#!/bin/bash
# Don't forget to adjust the permissions with:
# chmod+x ~/somecrazyfolder/script1
# Restructure this you animal, it's a fucking nightmare
# down there below the help fucking christ

# * Preliminary
# use spacemacs and:
  #Use C-c C-n and C-c C-x and C-c C-z and C-c C-( and sh-if and sh-for
  # There's also snippets, use =company-yasnippet=
    # LaTeX in Vim but Bash in emacs
        # Probably R in Rstudio (and some vim for math and maybe emacs for folding)

#' TODO move the 00TagMatch directory under ~/Documents without
#' breaking anything (because the whole script is relative),
#' do this in order to:
#'     + have consistency between =YAML= tags and =#tags=
#'     + not have duplicates in Notable
#' This isn't gamebreaking like the =YAML= tags were so i'll
#' leave it for now, but, for the most part this is something I should get around to.

# ** TODO Fix all this
# Make an alias to jump directly to a note rather than recreating a symlink
# and/or just us tmsu?
# Rewrite this script much neater

# * Program

# ** Description
# This will search and filter tags in the ~/Notes directory, returning results into temporary file and working from that

# ** Code

     notes_dir=~/Notes/MD/notes
     cd $notes_dir
     match_list=/tmp/00TagMatchList       # Not yet implemented
     match_dir=/tmp/00TagMatchDir         # Not yet implemented

# *** Help Statement
if [ "$1" == "-h" ] || [ "$1" == "--help"  ]; then
  echo "


Table of Contents
─────────────────

1. `basename $0`
2. `basename $0` -s
.. 1. `basename $0` -s m/e/z/t/c
3. YAML Filtering
..... 1. Return Results
..... 2. List Files
..... 3. TODO Make Symlinks

1 `basename $0`
═══════════════
  
  This will offer, concurrently, tags to filter notes by and write files
  that match into a temporary file.


2 `basename $0` -s
════════════════════

  This will create symlinks to the filtered files and use ag to locate
      the last tags line number.


2.1 `basename $0` -s m/e/z/t/c
────────────────────────────────

  This will open that directory in /MarkText/, emacs, /Zettler/,
  	/Typora/ or /VSCode/ respectively.


Table of Contents
─────────────────



3 YAML Filtering
════════════════

TODO Remove 00tags.csv from allowable search results

  switch to this mode by using `basename $0` -y.

  This will offer a selection of the =YAML= tags used in your notes


3.0.1 Return Results
╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌

  By default ripgrep is used to filter out the matching notes and then
  =ag= searches over those matches (yeah this is double handling but
  =ripgrep= was already implemented and most of the time you probably
  wont the note names, the only reason I used =ag= afterwards was
  because =sag= [1] offers the luxury of creating shortcuts mapped to =F
  \d=.


3.0.2 List Files
╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌

  use the =f= argument after the =-y= argument, so something like this:

  ┌────
  │ `basename $0` -y f
  └────

  This will return a list of files


3.0.3 TODO Make Symlinks
╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌

  This hasn=t yet been implemented, I could have implemented it just
  like =#tags= but It would be nice to tie this into TMSU somehow and
  it seems well suited so I might leave it rather than recreating work
  other people have already done


1.0.4 Regenerate Tags
╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌

  The =g= argument will regenerate tags using the =ListTags.R= script.
  This script is pretty quick (like 80ms) even though it runs a loop.
  Calling from bash adds 200 ms to it though, so is should scale well.



  ┌────
  │ `basename $0` -y g
  └────



Footnotes
─────────

[1] [GitHub - sampson-chen/sack: s(hortcut)-ack: a faster way to use
ag, ack (or grep)!] (<https://github.com/sampson-chen/sack>)

	       "
  exit 0


  # *** Pass the Tags to TMSU
  # This should really come after the generated part but I through it in here so it could be an else if, that wasn't clever?
elif [[ "$1" == *--tmsu* ]]; then
    cd ~/Notes/MD/
    # So this first searches for md files then greps them:
    # find ./ -name '*.md' | xargs rg --pcre2 '(?<=\s#)[a-zA-Z]+(?=\s)' *.md -o \
        #     | sed s+:+\ + | sed s/^/tmsu\ tag\ / | bash
    # This one only searches through markdown files (use rg --type-list)
    rg --pcre2 '(?<=\s#)[a-zA-Z]+(?=\s)' -t markdown -o \
        | sed s+:+\ + | sed s/^/tmsu\ tag\ / | bash
  # **** TODO Mount the TMSU somewhere
#    Do I want to do this everytime?
    # mkdir 00HashTags
    # tmsu mount 00HashTags
# *** Show the Filtered Content
  # This should really come after the generated part but I through it in here so it could be an else if, that wasn't clever?
elif [[ "$1" == *-s* ]]; then
     # make sure newlines not spaces are seperators
      IFS=$'\n'

# **** restore the last TagValue
     tagval=$(cat /tmp/thelasttagfromTagFilter)
# **** Create the Symlinks
     # This is supposed to be run second,
     # In order to take the filtered tags and put them in the symlinked directory
     echo "Symlinking and Showing the Filtered tags"
     mkdir 00TagMatch
      rm 00TagMatch/*
      ln -s $(realpath $(cat 00TagMatchList)) ./00TagMatch; rm 00TagMatchList
      cd 00TagMatch;
      sag -f "\s#$tagval" ./
      if [[ "$2" == *m* ]]; then
          marktext . & disown;
      fi
      if [[ "$2" == *t* ]]; then
          typora . & disown;
      fi
      if [[ "$2" == *e* ]]; then
          emacsclient --create-frame . & disown
      fi
      if [[ "$2" == *z* ]]; then
          zettlr . & disown
      fi
      if [[ "$2" == *c* ]]; then
          code . & disown
      fi
# **** TODO Feed to TMSU
#      for i in *.md in ; do
#         echo tmsu tag $i $(rg '(?<=#)[a-zA-z0-9](?=\s)' -o --no-filename)
#              tmsu tag $i $(rg '(?<=#)[a-zA-z0-9](?=\s)' -o --no-filename)
#      done
      # TODO should I use Xargs instead of a loop? probably this looks good though???? I can't think
# *** Yaml Tag Filtering
elif [[ "$1" == *-y* ]]; then
# **** Regenerate List (calling ListTags.R)
    # Filter based on the Yaml Tags, option g will regen list
    if [[ "$2" == *g* ]]; then
        Rscript ~/bin/ListTags.R
       # cat 00tags.csv  | rg '[a-zA-Z0-9]+/[a-zA-Z0-9/]+'  | fzf | xargs sag
    fi
# **** List the files Matching the Filter
    if [[ "$2" == *f* ]]; then
        cat /tmp/00tags.csv  | rg ''  | fzf | xargs -d '\n' rg -l > /tmp/kdkdjaksd; cat /tmp/kdkdjaksd | \
            fzf --preview 'cat {}'
      exit 0 # pipe doesn't work well here
    fi

# ***** List only the notebooks Matching the Filter
    if [[ "$2" == *n* ]]; then
       cat /tmp/00tags.csv  | rg '[a-zA-Z0-9]+/[a-zA-Z0-9/]+'  | fzf | xargs -d '\n' rg -l > /tmp/kdkdjaksd; cat /tmp/kdkdjaksd
      exit 0 # pipe doesn't work well here
    fi

# **** Preview matches in =fzf --preview=
    if [[ "$2" == *z* ]]; then
       cat /tmp/00tags.csv  | rg '[a-zA-Z0-9]+/[a-zA-Z0-9/]+'  | fzf | xargs rg -l > /tmp/kdkdjaksd; cat /tmp/kdkdjaksd | fzf --preview 'cat {}'
       exit 0
    fi
# **** Create sag shortcuts for the Tag (TODO this is slow)
    cat /tmp/00tags.csv  | rg '[a-zA-Z0-9]+/[a-zA-Z0-9/]+'  | fzf | xargs sag
    exit 0
else
# *** Filter out the tags must Run First (TODO this should be at the top of the script)
    # This is supposed to be run first, as many times as necessary
    # It will filter out the tags

      # Make new line Characters seperators for for loops
      IFS=$'\n'

      # Make a temp file to store results if necessary
     if test -f 00TagMatchList; then
            	echo "subsequent search";
     else
              # List in order of modification Date, top newest
            	# ls -t *.md > 00TagMatchList; 
            	find ./ -name '*.md' | sort > 00TagMatchList;

     fi
     
# **** Unused Slow Method
     # Have the user choose a tag from all the tag matches
#     tagval=$(for i in $(cat 00TagMatchList); do
#        rg --pcre2 --no-pcre2-unicode --no-filename '(?<=[\n\s]#)[a-zA-z]+(?=[\s\n$])' -o $i;
#     done | fzf)

	     # Remove Duplicates (This is slower, because the tags are listed by recency by default,
                     #  duplicates act as frequency for fzf I guess shrug)
#	     tagval=$(for i in $(cat 00TagMatchList); do
#	        rg --pcre2 --no-pcre2-unicode --no-filename '(?<=[\n\s]#)[a-zA-z]+(?=[\s\n$])' -o $i;
#	     done | sort -u | fzf)

# **** Revised faster method
    # Don't do the loop, this is like 10 times faster
        # With Repetition
     # tagval=$(cat 00TagMatchList | xargs -d '\n' rg --pcre2 --no-pcre2-unicode --no-filename '(?<=[\n\s]#)[a-zA-z]+(?=[\s\n$])' -o | fzf)
         # Duplicates Removed
     tagval=$(cat 00TagMatchList | xargs -d '\n' rg --pcre2 --no-pcre2-unicode --no-filename '(?<=[\n\s]#)[a-zA-z]+(?=[\s\n$])' -o | sort -u | fzf)

# **** Search through files for selected tag (iff fzf returned a term)
     # Return any files that contain that tag 
       # TODO join this with the above step for efficiency
     # Have ripgrep find files that contain that tag
      if [[ -z $tagval ]]; then
          echo '
 	         wait for fzf to finish otherwise ripgrep has
		 nothing with which to filter files with and
		 returns everything, recursively, 
		 TODO This breaks symlinks but shouldnt?
            Investigate if this will scale to nested directories?
                '
          exit 1
      else
	     cat 00TagMatchList | xargs rg ":$tagval:|\s#$tagval\s" -l > 00TagMatchList;
      fi
     
     # Space 
     echo "
          
     "

# **** Print Matching Tags Tags
     bat 00TagMatchList

# **** Save the last used tag so you can use `ag` on the preview later with it
     echo $tagval > /tmp/thelasttagfromTagFilter
     
     exit 0
fi

## vim:fdm=expr:fdl=0
## vim:fde=getline(v\:lnum)=~'^##'?'>'.(matchend(getline(v\:lnum),'##*')-2)\:'='



# If you need GNU tools, use grep not ripgrep
    # grep -P --no-filename '(?<=[\n\s]#)[a-zA-z]+(?=[\s\n$])' -o $i;





## vim:fdm=expr:fdl=0
## vim:fde=getline(v\:lnum)=~'^##'?'>'.(matchend(getline(v\:lnum),'##*')-2)\:'='
