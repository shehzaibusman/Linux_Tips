bindkey '^[f' forward-word
bindkey '^[b' backward-word

HISTFILE=~/.zsh_history
HISTSIZE=100000  # Store up to 100,000 commands in memory (session history)
SAVEHIST=100000  # Store up to 100,000 commands in memory (session history)
setopt INC_APPEND_HISTORY       # Add commands to history immediately
setopt SHARE_HISTORY            # Share history across all sessions
HISTTIMEFORMAT="%F %T "  # This will add the timestamp before each command in history

#alias history="history -i"
#alias history="history 1"
#alias history="fc -li 100"
alias history="fc -li 100"
setopt EXTENDED_HISTORY

# Enable colors for ls
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Enable color support for grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Git color
git config --global color.ui auto

autoload -U colors && colors
PROMPT="%B%F{green}%n@%m%f%b %F{blue}%~%f %F{yellow}%#%f "
#PROMPT="%F{green}%n@%m%f %F{blue}%~%f %# "


############
## BREW
############
export PATH="$HOME/.homebrew/bin:$PATH"
export HOMEBREW_NO_ANALYTICS=1
