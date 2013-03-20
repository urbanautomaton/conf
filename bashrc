# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# If this is an interactive shell...
case "$-" in
  *i*)
    # ...make bash autocomplete with up arrow
    bind '"\e[A":history-search-backward'
    bind '"\e[B":history-search-forward'
esac

function git_ps1_fast() {
  local dir="$PWD"
  local git_dir

  until [[ -z "$dir" ]]; do
    git_dir="$dir/.git"
    if [[ -d "$git_dir" ]]; then
      echo " (`git rev-parse --abbrev-ref HEAD`)"
      return
    fi

    dir="${dir%/*}"
  done
}


function append_path() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="${PATH:+"$PATH:"}$1"
  fi
}

function prepend_path() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="$1${PATH:+":$PATH"}"
  fi
}

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color) color_prompt=yes;;
  xterm-256color) color_prompt=yes;;
  screen-256color) color_prompt=yes;;
esac

if [ "$color_prompt"=yes ]; then
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(git_ps1_fast) \$ '
else
  PS1='\u@\h:\w\$ '
fi
unset color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac


# Alias definitions
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
  eval "`dircolors -b`"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# OSX dependent stuff
case `uname` in
'Darwin')
# Mac specific settings
  alias git='hub'
  alias vi='open -a MacVim.app'
  export EDITOR="vim"
  function edit()
  {
      /Applications/TextEdit.app/Contents/MacOS/TextEdit $@ 2>/dev/null
  }
  function nf()
  {
    grep -rin $@ ~/notes
  }
  append_path ~/dev/tools/android/tools
  append_path ~/dev/tools/android/platform-tools
  append_path /usr/local/mysql/bin
  ulimit -S -n 2048
# End Mac specific settings
;;
'Linux')
# Linux specific settings
  alias vi='vim'
# End Linux specific settings
;;
esac


# Host-specific bashrc if present
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi


if [ -f ~/.git-completion ]; then
  . ~/.git-completion
fi

# AWS toolkit variables
export EC2_HOME=$HOME/.ec2
export EC2_PRIVATE_KEY=$EC2_HOME/pk-23AHI74KQ3OGF4W7ZDQIPH6ETKPEJTHF.pem
export EC2_CERT=$EC2_HOME/cert-23AHI74KQ3OGF4W7ZDQIPH6ETKPEJTHF.pem
export JAVA_HOME=/opt/openjdk7
export EC2_URL=https://ec2.us-west-1.amazonaws.com

# Ruby epic FASTNESS
export RUBY_HEAP_MIN_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=100000000
export RUBY_HEAP_FREE_MIN=500000

append_path $HOME/bin
append_path $EC2_HOME/bin
append_path /usr/local/sbin

if [[ -f "/usr/local/share/chruby/chruby.sh" ]]; then
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh
  source ~/conf/scripts/chgems_auto.sh
fi
