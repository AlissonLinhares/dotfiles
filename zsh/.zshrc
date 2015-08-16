autoload -U colors select-word-style
select-word-style bash
colors

# Algumas funções úteis
function getDirectoryName() {
	if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] ; then
		if [[ $(git status --porcelain | wc -l) == 0 ]] ; then
			echo "%F{green}%~%f";
		else
			echo "%F{red}%~%f";
		fi
	else
		echo "%~";
	fi
}

function getExitCode() {
	local code=$?
	if [[ $code -ne 0 ]]; then
		echo "%F{red}-$code-%f"
	fi
}

function display() {
	xrandr --output LVDS1 --mode 1366x768 --right-of VGA1 --output VGA1 --mode 1920x1080
}

function lock() {
	xscreensaver & xscreensaver-command -lock
}

function expand-or-complete-or-list-files() {
	if [[ $#BUFFER == 0 ]]; then
		BUFFER="ls "
		CURSOR=3
		zle list-choices
		zle backward-kill-word
	else
		zle expand-or-complete
	fi
}

# Configurando o comportamento do histórico
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=${HOME}/.zsh/history

setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt NO_HIST_BEEP
setopt HIST_VERIFY

# Ativando alguns recursos legais
setopt PROMPT_SUBST
setopt NO_BEEP
setopt AUTO_CD
setopt AUTO_PARAM_SLASH
setopt AUTO_LIST
unsetopt AUTO_PARAM_KEYS

setopt EXTENDED_GLOB
setopt CORRECT
setopt GLOB_COMPLETE

# Melhorando o autocomplete
setopt COMPLETE_ALIASES
unsetopt COMPLETE_IN_WORD
setopt HASH_LIST_ALL
setopt ALWAYS_TO_END
setopt LIST_PACKED
setopt LIST_ROWS_FIRST
setopt LIST_TYPES
setopt LIST_AMBIGUOUS
setopt AUTO_MENU
setopt MENU_COMPLETE
# setopt CASE_GLOB
# setopt GLOB_DOTS

# Ativando o autocomplete com <tab>
autoload -U compinit promptinit
compinit
promptinit

# Carregando módulos úteis
zmodload -i zsh/complete
zmodload -i zsh/complist
zle -N expand-or-complete-or-list-files

# Personalizando o funcionamento de algumas teclas
bindkey -e
bindkey '^I' expand-or-complete-or-list-files
bindkey '^[[Z' reverse-menu-complete
bindkey '^p' history-beginning-search-backward
bindkey '^n' history-beginning-search-forward
bindkey -M menuselect '^M' .accept-line
bindkey -M menuselect '^b' vi-backward-char
bindkey -M menuselect '^p' vi-up-line-or-history
bindkey -M menuselect '^f' vi-forward-char
bindkey -M menuselect '^n' vi-down-line-or-history
bindkey -M menuselect " " accept-search

# Configurando o funcionamento do tab completion
zstyle ":completion:*:commands" rehash 1
zstyle ':completion:*' completer _expand _complete
zstyle ':completion::complete:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'e:|[._-]=* e:|=*' 'l:|=* e:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' verbose yes
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=29=34"
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*' force-list always
zstyle '*' single-ignored complete

# Configurando o formato do prompt
export PS1='%F{green}%B%M[%b%f$(getDirectoryName)%F{green}%B]%b%f> '
export RPS1='$(getExitCode)'
export PS2="> "
export PS3="> "
export PS4="> "

# Ativando cores dos principais comandos
eval `dircolors -b`
alias ls='ls --color=always'
alias dir='dir --color=always'
alias vdir='vdir --color=always'
alias grep='grep --color=always'
alias fgrep='fgrep --color=always'
alias egrep='egrep --color=always'

# Importando plugins
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-extract/extract.zsh
