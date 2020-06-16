# Import tags to TMSU
> [Home](../README.md)

## Requirements

* **_R_** <sup>(I'm on v 4.0, I don't know if that matters)</sup>
  * [Tidyverse](https://cran.r-project.org/web/packages/tidyverse/index.html)
      * [See there website](https://www.tidyverse.org/)
  * [RMarkdown](https://cran.r-project.org/web/packages/rmarkdown/index.html)
  * [ripgrep](https://github.com/BurntSushi/ripgrep)
* [TMSU](https://tmsu.org/)
* [GNU Stow](https://www.gnu.org/software/stow/) is recommended

### MD Files
* Syntactically correct file names
    * no `()#!/\` or whitespace characters
        * WikiJS uses `-` instead of space so I use that, as opposed to `_`
    * TODO surround the file names in the **_R_**-*Script* with `''` to hide whitespace from the shell
* Tags are not logical operators
    * don't have tags that are `and`, `or` or `not`

## Installation
Copy the following files into `~/bin`:

* `./bin/YamltoTMSU.R`
* `./bin/hashtags.sh`
* `./bin/tags-to-TMSU.sh`

So for example:

```
mkdir -p ~/DotFiles/Note-Taking-Tools
git clone https://github.com/RyanGreenup/Note-Taking-Tools ~/DotFiles/Note-Taking-Tools
cd ~/DotFiles
stow -t $HOME -S Note-Taking-Tools
```

## How to use

### Initialize TMSU
First go to your notes directory and initialise a tmsu database with `tmsu init`.

### `#`tags
In order to pass`#tags` to *TMSU* run the following (assuming `~/bin` is in your PATH):

```bash
cd ~/Notes/MD/notes
hashtags.sh

## Alternatively
## hashtags.sh /path/to/notes
```
After reviewing the output, pipe it into `bash`/`zsh`:

```bash
cd ~/Notes/MD/notes
hashtags.sh | bash
```

### *YAML* Tags

In order to pass `YAML` tags to *TMSU* use the **_R_***-*Script*:

```bash
Rscript ~/bin/YamltoTMSU.R ~/Notes/MD/notes
cat /tmp/00tags.csv
```

After reviewing the output pipe it into bash:

```bash
Rscript ~/bin/YamltoTMSU.R ~/Notes/MD/notes
cat /tmp/00tags.csv | bash
```

### Automated Script

Alternatively you can perform all of this from a script, but in the unlikel
scenario where there is *dangerous* text inside your tags (e.g. `rm -rf` or
`chown -R`) this may cause grief so be careful:

```bash
tags-to-TMSU.sh ~/Notes/MD/notes
```

