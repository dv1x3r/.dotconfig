export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' %F{39}%b%f'

setopt PROMPT_SUBST
export PROMPT='%2~%F{39}${vcs_info_msg_0_}%f %% '
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

export EDITOR="nvim"
alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias ll="ls -laFG"

