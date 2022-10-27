export PATH="/opt/homebrew/opt/python@3.10/bin:$PATH"
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1] /p'
}

setopt PROMPT_SUBST
#export PROMPT='%F{243}%n@%m%f %F{197}%2~%f %F{39}$(parse_git_branch)%f%% '
export PROMPT='%2~ %F{39}$(parse_git_branch)%f%% '
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

export EDITOR="nvim"
alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias ll="ls -laFG"

