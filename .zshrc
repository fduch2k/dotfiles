HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000000
SAVEHIST=1000000000

setopt promptsubst
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

### Added by Zinit's installer
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

WORDCHARS=${WORDCHARS/\/}

zmodload zsh/terminfo

# zplug "modules/tmux",       from"prezto"
#zplug "modules/history",    from"prezto"
#zplug "modules/utility",    from"prezto"
#zplug "modules/terminal",   from"prezto"
#zplug "modules/editor",     from"prezto"
#zplug "modules/directory",  from"prezto"
#zplug "modules/completion", from"prezto"

# test -e "${HOME}/." && source

# Install gir extras
zi lucid wait'0a' for \
as"program" pick"$ZPFX/bin/git-*" src"etc/git-extras-completion.zsh" make"PREFIX=$ZPFX" tj/git-extras

# Zplug plugins
# zi self-update

# zsh users
zi ice wait"0"
zi light "zsh-users/zsh-completions"

zi ice wait"2"
zi light "zsh-users/zsh-autosuggestions"

zi ice atinit"zicompinit; zicdreplay"
zi light "zdharma-continuum/fast-syntax-highlighting"

zi ice wait"3"
zi light "zsh-users/zsh-history-substring-search"

zi ice silent wait as"program" from"gh-r" pick"bat/bat" mv"bat* -> bat"
zi light sharkdp/bat

zi ice silent wait as"program" from"gh-r" pick"fd/fd" mv"fd* -> fd"
zi light sharkdp/fd

zi ice silent wait as"program" from"gh-r" pick"duf/duf"
zi light muesli/duf

zi ice silent wait as"program" from"gh-r" mv"dua*/dua -> dua" pick"dua"
zi light Byron/dua-cli

zi ice silent wait as"program" from"gh-r" pick"dust/dust" mv"dust* -> dust"
zi light bootandy/dust

zi ice as"completion"
zi snippet https://github.com/sharkdp/fd/blob/master/contrib/completion/_fd

# Plugins from oh my zsh
zi ice atload"unalias grv"

zi snippet OMZP::git

if command -v code >/dev/null 2>&1; then
  zi snippet OMZP::vscode
fi

zi snippet OMZP::zsh-interactive-cd
zi snippet OMZP::colored-man-pages
zi snippet OMZL::key-bindings.zsh

zi ice as"completion"
zi snippet OMZP::docker/completions/_docker

zi ice as"completion"
zi snippet OMZP::docker-compose/_docker-compose

zi light peterhurford/git-it-on.zsh

# Enhanced cd
# zi light "b4b4r07/enhancd", use:enhancd.sh


# RipGrep
zi ice silent wait as"program" from"gh-r" pick"rg/rg" mv"ripgrep* -> rg"
zi light 'BurntSushi/ripgrep'

# rmate
zi ice as"command" pick"rmate"
zi light aurora/rmate

# Tips for aliases
zi light "djui/alias-tips"

zi ice pick"z.sh"
zi light rupa/z

zi ice pick"async.zsh" src"pure.zsh"
zi light sindresorhus/pure

if [[ $(uname) == "Linux" ]]; then
  zi ice silent wait as"program" from"gh-r" pick"eza/eza"
  zi light eza-community/eza
fi

zi ice as"program" from"gh-r" pick"fzf" mv"fzf* -> fzf"
zi light junegunn/fzf
zi light Aloxaf/fzf-tab
zi light unixorn/fzf-zsh-plugin

zi ice as"program" from"gh-r" pick"jq" mv"jq* -> jq"
zi light "jqlang/jq"

zi ice as"program" from"gh-r" pick"delta/delta" mv"delta* -> delta"
zi light dandavison/delta

zi ice as"program" from"gh-r" pick"btm"
zi light ClementTsang/bottom

zi ice as"program" from"gh-r"
zi light zellij-org/zellij

zi ice wait"2"
zi light "lukechilds/zsh-better-npm-completion"
zi light lukechilds/zsh-nvm

zi ice as"program" from"gh-r" pick"orf/gping" mv"gping* -> gping"
zi light orf/gping

zi ice wait"3" as"program" from"gh-r" lucid sbin"**/glow"
zi light charmbracelet/glow

zi ice wait"3" from"gh-r" lucid sbin"**/fx* -> fx"
zi light @antonmedv/fx

# bind UP and DOWN arrow keys
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

export ZSH_PLUGINS_ALIAS_TIPS_TEXT=' alias hint: '
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# User configuration
export PATH="$HOME/.dotfiles/bin:$HOME/.bin:/usr/local/bin:$PATH"
export LANG=en_US.UTF-8
export EDITOR='nano'
export TERM="xterm-256color"
export KEYTIMEOUT=1

# :: Aliases and functions
alias b="bookmark"
alias bd="deletemark"
alias j="jump"
alias c="clear"
alias b2z='python $HOME/.bash-to-zsh-history.py'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Findfile and find content
function f() { find . -iname "*$1*" ${@:2} }
function r() { grep "$1" ${@:2} -R . }
function rgd() { rg --json -C 2 $* | delta }

# Install plugins if there are plugins that have not been installed
# if ! zplug check; then
#    zplug install
# fi

# Load everything
# zplug load

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# Modern Unix commands
# See https://github.com/ibraheemdev/modern-unix
# echo $+commands[eza]
if (( $+commands[eza] )); then
    alias ls='eza --git --icons --group --color=auto --icons --group-directories-first'
    alias l='eza -lhF --git --icons --group --color=auto --icons --group-directories-first'
    alias la='eza -lhAF --git --icons --group --color=auto --icons --group-directories-first'
    alias tree='eza --tree --git --icons --group --color=auto --icons --group-directories-first'
elif (( $+commands[exa] )); then
    alias ls='exa --color=auto --icons --group-directories-first'
    alias la='ls -lahF'
    alias tree='ls --tree'
fi

alias ll="ls -la"

(( $+commands[bat] )) && alias cat='bat -p --wrap character'
(( $+commands[fd] )) && alias find=fd
(( $+commands[btm] )) && alias top=btm
(( $+commands[rg] )) && alias grep=rg
(( $+commands[tldr] )) && alias help=tldr
(( $+commands[delta] )) && alias diff=delta
(( $+commands[duf] )) && alias df=duf
(( $+commands[dust] )) && alias du=dust
(( $+commands[hyperfine] )) && alias benchmark=hyperfine
(( $+commands[gping] )) && alias ping=gping

# Local customizations, e.g. theme, plugins, aliases, etc.
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/fduch/.lmstudio/bin"
# End of LM Studio CLI section
