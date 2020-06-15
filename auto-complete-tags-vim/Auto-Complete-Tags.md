# Auto Complete Tags in Vim

This is essentially an easy way to get tags auto completed in vim.

## Requirements

+ [NodeJS](https://github.com/nodejs/node)
  + NPM Modules that are already included in this repo:
    + [yaml-front-matter](https://www.npmjs.com/package/yaml-front-matter)
    + [glob](https://www.npmjs.com/package/glob)
+ [Vim](https://github.com/neovim/neovim)
  + TODO Possibly *Emacs*
+ [fzf](https://github.com/junegunn/fzf)
+ [FZF.Vim](https://github.com/junegunn/fzf.vim)
+ `*nix` OS
  + This is really written with Linux in mind, presumably it would be totally compatible with [*FreeBSD*](https://github.com/freebsd/freebsd), *MacOS* and very possibly [*WSL*](https://docs.microsoft.com/en-us/windows/wsl/install-win10). 
    + On the balance of probabilities [*WSL*](https://docs.microsoft.com/en-us/windows/wsl/install-win10) would require a bit of trial/error

### Recommended

+ [GNU Stow](https://www.gnu.org/software/stow/) will make life a little easier with respect to copying scripts etc.
+ [Vim-Plug](https://github.com/junegunn/vim-plug)
  + This will make [FZF.Vim](https://github.com/junegunn/fzf.vim) easier to install.
+ [ripgrep](https://github.com/BurntSushi/ripgrep)
  + This provides an easy way to insert `#tags`
    + I'll post up a simple **_R_** script to pass `#tags` to [[TMSU](https://tmsu.org/) after exams and put a link here.

## Usage

1. Download the `printMarkdownTags` folder to `~/bin/`
   1. Alternatively download it to `~/DotFiles/Scripts/bin` and then perform `stow -S -t $HOME ~/DotFiles/Scripts`
2. Install [FZF.Vim](https://github.com/junegunn/fzf.vim)
4. If youre Notes are in `~/Notes/MD/notes` then Add the following to your `~/.vimrc` (and/or possibly `~/.config/nvim/init.vim`), otherwise modify the directory to match your flavour:
   
```vim
imap <expr> <C-c><C-y> fzf#vim#complete('node ~/bin/printMarkdownTags/yaml-parse.js $HOME/Notes/MD/notes \| sort -u')
imap <expr> <C-c><C-t> fzf#vim#complete('rg --pcre2 "\s#[a-zA-Z-@]+\s" -o --no-filename $HOME/Notes/MD -t md \| sort -u')
```

4. Open a fresh vim instance, open a markdown file and hit `C-c C-y`, you should get a popup of all the yaml tags in the notes folder.

### Demo

Check out this quick `gif`:

![](media/vimYAML.gif)

## Other Useful Vim Integrations for Notable

+ Searching
  + It is very simple to integrate a terminal search with [recoll](https://www.lesbonscomptes.com/recoll/) such that you never need to leave your terminal.
    + TODO Put up this script
    + [Notational-fzf-vim](https://github.com/alok/notational-fzf-vim) is essentially a vim front end for fzf and ripgrep, not as powerful as `recoll` but handy if you know the exact term your looking for 
+ Tags
  + It's easy to pass both `#tags` and `yaml` tags to TMSU so that you can browse them using mount
    + TODO Post this script up

### Alternative Method

I initially tried this in **_R_** because I didn't actually know any *JavaScript*, but it was too slow, the tags took just long enough to pop up that I found it irritating and did it in JS, if you want to play around with that **_R_**-script you can add the following to your vimrc:

```vim
"" RScript to give tags to FZF
imap <expr> <C-c><C-r> fzf#vim#complete('Rscript ~/bin/ListTags.R >  /dev/null 2>&1; cat /tmp/00tags.csv')
```


## TODO Emacs

This should also work inside *Emacs* in a very similar way, when time permits I'll figure it out.
