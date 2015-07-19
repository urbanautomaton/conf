#! /bin/sh

case `uname` in
  'Darwin')
    dircmd='ln -sfh'
    ;;
  'Linux')
    dircmd='ln -sfT'
    ;;
esac

readonly DOTDIRECTORIES="
  vim
  git_template
"

readonly DOTFILES="
  bashrc
  bash_aliases
  inputrc
  vimrc
  irbrc
  gemrc
  pryrc
  git-completion
  gitconfig
  gitignore_global
  gitattributes
  gvimrc
  ackrc
  tmux.conf
  tmux-osx.conf
"

for dir in $DOTDIRECTORIES; do
  if [[ -n "$dir" ]]; then
    $dircmd ~/dotfiles/$dir ~/.$dir
  fi
done

for file in $DOTFILES; do
  if [[ -n "$file" ]]; then
    ln -sf ~/dotfiles/$file ~/.$file
  fi
done

mkdir -p ~/bin
for script in $(ls ~/dotfiles/bin); do
  ln -sf ~/dotfiles/bin/$script ~/bin/$script
done
