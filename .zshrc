HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000000
SAVEHIST=1000000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.

# mkcd is equivalent to takedir
function mkcd takedir() {
  mkdir -p $@ && cd ${@:$#}
}

function takeurl() {
  local data thedir
  data="$(mktemp)"
  curl -L "$1" > "$data"
  tar xf "$data"
  thedir="$(tar tf "$data" | head -n 1)"
  rm "$data"
  cd "$thedir"
}

function takegit() {
  git clone "$1"
  cd "$(basename ${1%%.git})"
}

function take() {
  if [[ $1 =~ ^(https?|ftp).*\.tar\.(gz|bz2|xz)$ ]]; then
    takeurl "$1"
  elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
    takegit "$1"
  else
    takedir "$@"
  fi
}

export TONOSCLI_CONFIG=/home/ton/tonlabs-cli.conf.json

WORDCHARS=${WORDCHARS/\/}

zmodload zsh/terminfo

# :: Zplug - ZSH plugin manager
export ZPLUG_HOME=$HOME/.zplug

# Check if zplug is installed
if [[ ! -d $ZPLUG_HOME ]]; then
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
  source $ZPLUG_HOME/init.zsh && zplug update --self
fi

# Essential
source $ZPLUG_HOME/init.zsh

# Zplug plugins
zplug "zplug/zplug", hook-build:"zplug --self-manage"

# zplug "modules/tmux",       from:prezto
#zplug "modules/history",    from:prezto
#zplug "modules/utility",    from:prezto
#zplug "modules/terminal",   from:prezto
#zplug "modules/editor",     from:prezto
#zplug "modules/directory",  from:prezto
#zplug "modules/completion", from:prezto

# zsh users
zplug "zsh-users/zsh-completions",              defer:0
zplug "zsh-users/zsh-autosuggestions",          defer:2, on:"zsh-users/zsh-completions"
zplug "zdharma-continuum/fast-syntax-highlighting",       defer:3, on:"zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search", defer:3, on:"zdharma/fast-syntax-highlighting"

# Plugins from oh my zsh
zplug "plugins/gitfast", from:oh-my-zsh
zplug "plugins/git-it-on", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/vscode", from:oh-my-zsh
zplug "plugins/zsh-interactive-cd", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh
# zplug "plugins/github", from:oh-my-zsh
zplug "lib/key-bindings", from:oh-my-zsh, as:plugin

# Enhanced cd
zplug "b4b4r07/enhancd", use:enhancd.sh

# Bookmarks and jump
zplug "jocelynmallon/zshmarks"

# RipGrep
zplug 'BurntSushi/ripgrep', from:gh-r, as:command, rename-to:"rg"

# rmate
zplug 'aurora/rmate', as:command, use:rmate

# Enhanced dir list with git features
zplug "supercrabtree/k"

# Tips for aliases
zplug "djui/alias-tips"

# Docker completion
# zplug "felixr/docker-zsh-completion"

zplug "rupa/z", use:z.sh
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug "vmchale/tin-summer", as:command, from:gh-r, rename-to:"sn", use:"*x86_64*linux*", if:"[[ $OSTYPE == *linux* ]]"
zplug "vmchale/tin-summer", as:command, from:gh-r, rename-to:"sn", use:"*x86_64*apple*", if:"[[ $OSTYPE == *darwin* ]]"
zplug "sharkdp/bat", as:command, from:gh-r, rename-to:"bat", use:"*x86_64*linux-gnu*", if:"[[ $OSTYPE == *linux* ]]"
zplug "sharkdp/bat", as:command, from:gh-r, rename-to:"bat", if:"[[ $OSTYPE == *darwin* ]]"
zplug "sharkdp/fd", as:command, from:gh-r, rename-to:"fd", use:"*x86_64*linux-gnu*", if:"[[ $OSTYPE == *linux* ]]"
zplug "sharkdp/fd", as:command, from:gh-r, rename-to:"fd", use:"*x86_64*darwin*", if:"[[ $OSTYPE == *darwin* ]]"
zplug "stedolan/jq", from:gh-r, as:command, rename-to:jq
zplug "dandavison/delta", as:command, from:gh-r, rename-to:"sn", use:"*x86_64*linux*", if:"[[ $OSTYPE == *linux* ]]"
zplug "dandavison/delta", as:command, from:gh-r, rename-to:"sn", use:"*x86_64*apple*", if:"[[ $OSTYPE == *darwin* ]]"
# zplug "tstack/lnav", from:gh-r, as:command
zplug "junegunn/fzf", as:command, from:gh-r, rename-to:fzf
# zplug "junegunn/fzf", use:"shell/*.zsh"
zplug "Aloxaf/fzf-tab"
zplug "unixorn/fzf-zsh-plugin"
zplug "lotabout/skim", as:command, from:gh-r, rename-to:skim
zplug "ClementTsang/bottom", as:command, from:gh-r, rename-to:bottomz
zplug "zellij-org/zellij", as:command, from:gh-r, use:"*x86_64*linux*", if:"[[ $OSTYPE == *linux* ]]"
zplug "zellij-org/zellij", as:command, from:gh-r, use:"*x86_64*apple*", if:"[[ $OSTYPE == *darwin* ]]"
zplug "zellij-org/zellij", as:command, from:gh-r, use:"*x86_64*apple*", if:"[[ $OSTYPE == *apple* ]]"
zplug "arzzen/calc.plugin.zsh"
zplug "ptavares/zsh-exa"

# bind UP and DOWN arrow keys
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

export ZSH_PLUGINS_ALIAS_TIPS_TEXT=' alias hint: '

# User configuration
export PATH="$HOME/.dotfiles/bin:$HOME/.bin:/usr/local/bin:$PATH"
export LANG=en_US.UTF-8
export EDITOR='nano'
export TERM="xterm-256color"
export KEYTIMEOUT=1

# :: Aliases and functions
alias l="ls"
alias ll="ls -al"
alias kk="k -a"
alias b="bookmark"
alias bd="deletemark"
alias j="jump"
alias c="clear"
alias b2z='python $HOME/.bash-to-zsh-history.py'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Findfile and find content
function f() { find . -iname "*$1*" ${@:2} }
function r() { grep "$1" ${@:2} -R . }

# Install plugins if there are plugins that have not been installed
if ! zplug check; then
   zplug install
fi

# Load everything
zplug load
