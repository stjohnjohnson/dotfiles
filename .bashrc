# Source .bashrc for non-interactive Bash shells
export BASH_ENV=~/.bashrc

if [[ $- != *i* ]] ; then
  # Shell is non-interactive.  Be done now!
  return
fi

# Get the OS
OS=$(uname | awk '{print tolower($1)}')

_setaliases() {
  alias ls='ls -G'
  alias ll='ls -ahlG'
  alias grep='grep --color=auto'
  alias p="ps aux |grep "
  alias dotfiles='git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
}

_sethistory() {
  export HISTFILE=~/.bash_history
  export HISTSIZE=10000
  export HISTFILESIZE=${HISTSIZE}
  export HISTCONTROL=ignoredups:ignorespace
  shopt -s histappend

  # Do *not* append the following to our history:
  HISTIGNORE='\&:fg:bg:ls:pwd:cd ..:cd ~-:cd -:cd:jobs:set -x:ls -l:ls -l'
  HISTIGNORE=${HISTIGNORE}':%1:%2:popd:top:shutdown*'
  export HISTIGNORE

  # Save multi-line commands in history as single line
  shopt -s cmdhist
}

_sources() {
  local sources=""
  sources="${sources} ${HOME}/.sources"
  sources="${sources} ${HOME}/.sources/bashrc/${HOSTNAME}.bashrc"
  sources="${sources} ${HOME}/.sources/bashrc/${OS}.bashrc"
  sources="${sources} ${HOME}/.bash_completion.d"

  for i in $sources; do
    # Source files
    if [ -f $i ]; then
      source $i
      continue
    fi

    # Source all files in a directory
    if [ -d $i ]; then
      for j in $i/*; do
        if [ -f $j ]; then
          source $j
        fi
      done
    fi
  done
}

_setprompt() {
  local BLUE="\[\033[0;34m\]"
  local LIGHT_BLUE="\[\033[1;34m\]"
  local CYAN="\[\033[1;36m\]"
  local RED="\[\033[0;31m\]"
  local LIGHT_RED="\[\033[1;31m\]"
  local GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local WHITE="\[\033[1;37m\]"
  local LIGHT_GRAY="\[\033[0;37m\]"
  local CLEARCOLOR="\e[0m"

  PS1="[$LIGHT_RED\u$CLEARCOLOR@$LIGHT_BLUE\h$CLEARCOLOR \W$GREEN\$(parse_git_branch)$CLEARCOLOR]$ "
}

parse_git_branch() {
  if [ git ]; then
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
  fi
}

# Run all our fun set functions
_setprompt
_sethistory
_setaliases

# Correct minor spelling errors in cd commands
shopt -s cdspell
# Enable egrep-style pattern matching
shopt -s extglob
shopt -s checkwinsize

# Some fancy colors
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export TERM=ansi

# Set editor to vim
export EDITOR=/usr/bin/vim

# Set nethack
export NETHACKOPTIONS="number_pad,noautopickup,name:Caffeine,time,color,lit_corridor,catname:Fluffy,character:Barbarian,disclose:+i +a +v +g +c,female,race:orc,standout,sparkle,verbose,showexp,BOULDER=0"
export PATH=/usr/local/sbin:/usr/local/bin:/usr/local/Cellar/php/5.3.10/bin:$PATH

_sources
unset OS