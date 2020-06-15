# Import tags to TMSU
> [Home](../README.md)

## Requirements

* **_R_**
  * Tidyverse
* ripgrep
* TMSU

## Installation
Copy the following files into `~/bin`:

* `./bin/YamltoTMSU.R`
* `./bin/hashtags.sh`
* `./bin/tags-to-TMSU.sh`


## How to use

### Initialize TMSU
First go to your notes directory and initialise a tmsu database with `tmsu init`.

### `#`tags
In order to pass`#tags` to *TMSU* run the following (assuming `~/bin` is in your PATH):

```bash
cd ~/Notes/MD/notes
hashtags.sh 
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

Alternatively you can perform all of this from a script, but in the unlikel scenario where there is *dangerous* text inside your tags (e.g. `rm -rf` or `chown -R`) this may cause grief so be careful:

```bash
tags-to-TMSU.sh ~/Notes/MD/notes
```

