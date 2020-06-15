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

First go to your notes directory and initialise a tmsu database with `tmsu init`.

In order to pass`#tags` to *TMSU* run the following (assuming `~/bin` is in your PATH):

```bash
hashtags.sh ~/Notes/MD
```
After reviewing the output, 

TODO If I pipe this to bash, it needs be run from the same directory anyway right? so taking the path as an argument is arguably misleading

In order to pass `YAML` tags to *TMSU*
