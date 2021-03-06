# List Backlinks

## Requirements

+ [xclip](https://github.com/astrand/xclip "Copy via terminal")
+ [ripgrep](https://github.com/BurntSushi/ripgrep "Faster Grep")
+ [sd (sed Alternative)](https://github.com/chmln/sd "A Faster Better sed")
+ Notes should ideally have unique and descriptive names like a Zettelkasten
  + Directories are fine
  + There's no need for UUID's, descriptive file names are much easier.


## How To

Put the following in your `bash`
Make a `bash` script, an alias or a function in
`~/.bashrc`/`~/.zshrc`/`~/.config/fish/config.fish` for the following piece of
bash:

```bash
function BackLinks() {
## If your using fish
  ## set term "$(xclip -selection clipboard -o | xargs basename |  cut -f 1 -d '.')"

## If your using bash/zsh
    term=$(xclip -selection clipboard -o | xargs basename |  cut -f 1 -d '.')
    
## The Grep
    rg -e "\[.*\]\(.*$term\.md\)" -e "\[\[$term\]\]" -e "\[\[$term.*\]\]" \
        ~/Notes/  -t markdown -ol
        
## If you want to preview the Backlinks
 ##  rg -e "\[.*\]\(.*$term\.md\)" -e "\[\[$term\]\]" -e "\[\[$term.*\]\]" \
 ##      ~/Notes/  -t markdown -ol \
 ##  fzf --bind pgup:preview-page-up,pgdn:preview-page-down --preview "mdcat {}"
}

alias bl='BackLinks'
```

## Usage

0. Make some `.md` files in `~/Notes` that are interlinked with `[[wiki-links]]` and `[markdown](./links.md)`
1. Copy the note path to the clipboard
    * I bind this to `SPC f y` in VSCode and Vim, [Check out my DotFiles here](https://github.com/RyanGreenup/DotFiles/blob/master/VSCode/.config/Code%20-%20OSS/User/settings.json)
2. Run the command from above
3. Anything that contains links to the current note should be returned.

### Building on it

You can get creative and turn these into wiki-links as well.

```bash
 bl | sed s/^/basename\ / | bash | cut -f 1 -d '.' | sed s/^/\[\[/ | sed s/\$/\]\]/
```
