###########
# HISTORY #
###########

# Ignore duplicate commands, space-prefixed, and misc boring cmds.
export HISTIGNORE="&:[ ]*:exit:gs:gl"
# Massive main .bash_history...
export HISTFILESIZE=10000
# Larger session histories...
export HISTSIZE=1000
# And don't overwrite .bash_history on exit
shopt -s histappend

##############
# Misc shell #
##############

# Use funky extended bash globbing:
# http://www.linuxjournal.com/content/bash-extended-globbing
shopt -s extglob
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

################
# Path helpers #
################

function append_path() {
  [[ ":$PATH:" != *":$1:"* ]] && export PATH="${PATH:+"$PATH:"}$1"
}

function prepend_path() {
  [[ ":$PATH:" != *":$1:"* ]] && export PATH="$1${PATH:+":$PATH"}"
}

function append_path_if_present() {
  [[ -d "$1" ]] && append_path "$1"
}

function prepend_path_if_present() {
  [[ -d "$1" ]] && prepend_path "$1"
}

function remove_from_path() {
  local readonly remove=$1
  local work=:$PATH:
  work=${work/:$remove:/:}
  work=${work#:}
  work=${work%:}
  export PATH=$work
}

append_path_if_present $HOME/bin
append_path_if_present /usr/local/sbin

######################
# Terminal wrangling #
######################

# set a fancy prompt
if [[ "$TERM" =~ color ]]; then
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1) \$ '
else
  PS1='\u@\h:\w\$ '
fi

# If this is an xterm set the title to user@host:dir
if [[ "$TERM" =~ xterm*|rxvt* ]]; then
  PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
fi

# Visible cucumber step locations
export CUCUMBER_COLORS=comment=cyan

#######################
# Ruby env management #
#######################

chruby_location=/usr/local/share/chruby/chruby.sh
if [[ -f "$chruby_location" ]]; then
  export CHRUBY_DEFAULT=2.2
  readonly CHRUBY_DEFAULT

  source $chruby_location
  chruby $CHRUBY_DEFAULT
fi

gem_home_location=/usr/local/share/gem_home/gem_home.sh
if [[ -f "$gem_home_location" ]]; then
  source $gem_home_location
fi

################
# And the rest #
################

# Alias definitions
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

# OS- and host-specific configuration
[[ -f ~/.bashrc.darwin ]] && . ~/.bashrc.darwin
[[ -f ~/.bashrc.local ]] && . ~/.bashrc.local

# Enable programmable bash command-line completion
[[ -f /etc/bash_completion ]] && . /etc/bash_completion

# Enable git command-line completion
[[ -f ~/.git-completion ]] && . ~/.git-completion

# Load environment hook scripts
[[ -f ~/.env_hooker ]] && . ~/.env_hooker

# Start a flame war
export EDITOR="vim"
