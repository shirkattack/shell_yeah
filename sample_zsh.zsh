# SAMPLE ZSH CONFIGURATION FILE - Use as inspiration to customize from scratch
# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set theme to powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# After Powerlevel10k configuration
function show_ascii_art() {
  cat << "EOF"
                         ..          
⠀⠀⠀⠀⠀⠀⣔⣮⣷⣾⣷⠆⢀⣄⠀     ............
⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣟⠀...................
⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⠏⠀⠙⠟⠀    ..............
⠀⠀⠀⠀⣠⣾⣿••⣿⣿⣿⣷⡆⠀⠀            ....
⠀⠀⣰⣾⣿⠿⠋⠀⠈⠋⣿⣿⠇⠀⠀⠀⠀           
⠀⠰⣿⠙⠁⠀⠀⠀⠀⠀⠿⣤⡀⠀⠀⠀⠀⠀

   _____ __    _      __         __  __             __  
  / ___// /_  (💥)____/ /______ _/ /_/ /_____ ______/ /__
  \__ \/ __ \/ / ___/ //_/ __ `/ __/ __/ __ `/ ___/ //_/
 ___/ / / / / / /  / ,< / /_/ / /_/ /_/ /_/ / /__/ ,<   
/____/_/ /_/_/_/  /_/|_|\__,_/\__/\__/\__,_/\___/_/|_|
EOF
}

# Plugins
plugins=(
  git
  docker
  kubectl
  npm
  yarn
  web-search
  copypath
  dirhistory
  history
  jsontools
  zsh-autosuggestions
	zsh-syntax-highlighting
)

# Source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# User configuration
export LANG=en_US.UTF-8
export EDITOR='vim'

# Aliases
alias zshconfig="$EDITOR ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"
alias reload="source ~/.zshrc"

# Directory shortcuts
alias ..='cd ..'
alias weather="curl wttr.in/"
alias myip="curl https://api.ipify.org\?format\=json; echo"
alias backup="sudo sh -c /usr/local/sbin/backup"
alias big="du -a -BM | sort -n -r | head -n 10"

alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# Docker aliases
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'

# System aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias h='history'
alias ports='netstat -tulanp'
alias mem='free -h'
alias df='df -h'

# Data preview alias for CSV and JSON files
alias preview="python3 $HOME/pimp_terminal/scripts/data_preview.py"

# Enhanced cd command
setopt AUTO_CD

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Auto-suggestions configuration
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'

# Completion system
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh