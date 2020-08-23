# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="nanotech"
#ZSH_THEME="theunraveler"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# tmux plugin config
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/tmux
export ZSH_TMUX_AUTOSTART="true"
export ZSH_TMUX_AUTOCONNECT="true"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	rbenv
	tmux
)

# Pre-compinit Custom
source $HOME/.homesick/repos/homeshick/homeshick.sh
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

# oh-my-zsh
source $ZSH/oh-my-zsh.sh
source $HOME/.profile

# Custom

background() {
  "$@" &
}

if [[ $(uname) == 'Darwin' ]]; then
	export GOPATH=$HOME/Desktop/Current/code/go
	alias code="cd $HOME/Desktop/Current/code"
fi

if [[ $(uname) == 'Linux' ]]; then
	alias subl="$HOME/.local/bin/sublime_text_3/sublime_text"
	alias sudosubl='env SUDO_EDITOR="$HOME/.local/bin/sublime_text_3/sublime_text -w" sudoedit'

	alias ff="background $HOME/.local/bin/firefox/firefox"

	alias xbpsi="sudo xbps-install -S "
	alias xbpsr="sudo xbps-remove "
	alias xbpss="xbps-query -R -s "
	alias xbpsu="sudo xbps-install -Syu"

	alias svps="sudo sv status /var/service/*"
	svup() {
	  dir=/etc/sv/"$1"
	  if [ ! -d "$dir" ]
	  then
	    echo "Path $dir doesn't exist"
	    return
	  fi
	  sudo ln -s "$dir" /var/service/
	}
	svdown() {
	  sudo rm -f /var/service/$1
	}

	# PyWal
	# Import colorscheme from 'wal' asynchronously
	# # &   # Run the process in the background.
	# # ( ) # Hide shell job control messages.
	if [[ -a "$HOME/.cache/wal/sequences" ]]; then
		(cat "$HOME/.cache/wal/sequences" &)
	fi

	# AwesomeWM
	alias awesome-restart="echo 'awesome.restart()' | awesome-client"
fi

# Amazon Laptop
if [[ $(hostname) =~ ".*ant.amazon.com" ]]; then
    alias start="diskutil unmount force ~/devbox; mwinit; sshfs desktop:workplace ~/devbox -o auto_cache -o follow_symlinks"

    export PATH=~/.toolbox/bin:$PATH
fi

# Amazon CDD
if [[ $(hostname) =~ "dev-dsk.*amazon" ]]; then
    alias bbr="brazil-build release"
    alias bb="brazil-build"

    export PATH=~/.toolbox/bin:$PATH:/apollo/env/envImprovement/bin
fi

zshrl() {
  source $HOME/.zshrc
  echo "Reloaded ~/.zshrc"
}

