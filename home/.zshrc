# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="nanotech"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="false"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

ZSH_TMUX_AUTOSTART="false"
ZSH_TMUX_AUTOCONNECT="false"
ZSH_TMUX_FIXTERM_WITH_256COLOR="true"

plugins=(
	rbenv
	tmux
)

# * load homeshick (dotfile manager) *
source $HOME/.homesick/repos/homeshick/homeshick.sh
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

# * set up user paths *
source $HOME/.profile

#
# * exports & aliases *
#
export GOPATH=$HOME/code/go
alias ff="$HOME/.local/bin/firefox/firefox > /dev/null 2>&1 & disown"
alias vim=nvim
alias nv=neovide --multigrid
alias drun='docker run -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v $(pwd):/pwd'
alias sd='drun --name sd l1naforever/stable-diffusion-rocm:baked'
alias locate="locate -d $LOCATE_PATH " # I don't maintain a system-wide locate db, so set mine as the *only* one
alias tmux='tmux -2' # force 256 color mode
alias void="KEYFILE=$HOME/.config/voidmap/keyfile void"

#
# * xbps helpers*
#
# TODO - remove, just use xtools
alias xbpsi="sudo xbps-install -S "
alias xbpsr="sudo xbps-remove "
alias xbpss="xbps-query -R -s "
alias xbpsu="sudo xbps-install -Su"

#
# * runit helpers *
#
alias svps="sv status ~/service/* ; sudo sv status /var/service/*"
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

zshrl() {
  source $HOME/.zshrc
  echo "Reloaded ~/.zshrc"
}

source $ZSH/oh-my-zsh.sh

