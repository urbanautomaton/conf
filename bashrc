##############
# Misc shell #
##############

# Use funky extended bash globbing:
# http://www.linuxjournal.com/content/bash-extended-globbing
shopt -s extglob
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

####################
# Helper Functions #
####################

function source_if_present() {
  # This warning complains about a non-constant source location, but that's
  # the point of this function, so. What're you gonna do eh?
  #
  # shellcheck disable=SC1090
  [[ -f "$1" ]] && source "$1"
}

function path_contains() {
  [[ ":$PATH:" == *":$1:"* ]]
}

function directory_exists() {
  [[ -d "$1" ]]
}

function command_exists() {
  type -t "$1" >/dev/null
}

function append_path() {
  path_contains "$1" || export PATH="${PATH:+"$PATH:"}$1"
}

function prepend_path() {
  path_contains "$1" || export PATH="$1${PATH:+":$PATH"}"
}

function append_path_if_present() {
  directory_exists "$1" && append_path "$1"
}

function prepend_path_if_present() {
  directory_exists "$1" && prepend_path "$1"
}

function append_prompt_command() {
  PROMPT_COMMAND=${PROMPT_COMMAND:+"${PROMPT_COMMAND}; "}$1
}

function remove_from_path() {
  local remove="$1"
  readonly remove
  local work=:$PATH:
  work=${work/:$remove:/:}
  work=${work#:}
  work=${work%:}
  export PATH=$work
}

###########
# HISTORY #
###########

# Ignore duplicate commands, space-prefixed, and misc boring cmds.
export HISTIGNORE="&:[ ]*:exit:gs:gl"
# Massive main .bash_history...
export HISTFILESIZE=10000
# Larger session histories...
export HISTSIZE=1000
# Nice timestamps...
HISTTIMEFORMAT='%F %T '
# Save multi-line commands as one command...
shopt -s cmdhist
# Save commands as they're issued...
append_prompt_command 'history -a'
# And don't overwrite .bash_history on exit
shopt -s histappend

#########################
# Custom PATH locations #
#########################

append_path_if_present "$HOME/bin"
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
  # This warning complains about the single quotes wrapping a string with
  # apparent string interpolations - however it's that way around precisely to
  # stop the interpolations happening at bashrc runtime.
  #
  # shellcheck disable=SC2016
  append_prompt_command 'echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
fi

# Visible cucumber step locations
export CUCUMBER_COLORS=comment=cyan

#######################
# Ruby env management #
#######################

source_if_present /usr/local/share/chruby/chruby.sh
source_if_present /usr/local/share/gem_home/gem_home.sh

if type -t chruby >/dev/null; then
  export CHRUBY_DEFAULT=2.3
  readonly CHRUBY_DEFAULT
  chruby $CHRUBY_DEFAULT
fi

################
# And the rest #
################

source_if_present ~/.bash_aliases
source_if_present ~/.bashrc.darwin
source_if_present ~/.bashrc.local

# Enable programmable bash command-line completion (Debian derivs)
source_if_present /etc/bash_completion
# Load custom completions
source_if_present ~/.bash_completion

# Enable bash completion in homebrew setups
if command_exists brew; then
  source_if_present /usr/local/etc/bash_completion
fi

# Load environment hook scripts
source_if_present ~/.env_hooker
load_env_hooks ~/.env_hooks

export GIT_PS1_SHOWDIRTYSTATE=1

# Start a flame war
export EDITOR="vim"
