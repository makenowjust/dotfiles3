#!/usr/bin/env bash

set -e

run() {
  if [[ -n "$DEBUG" ]]; then
    echo "$@"
  else
    eval "$@"
  fi
}

DOTFILES="$PWD"

for file in $(find .                                                   \
    -path "./.??*" -a                                                  \
    ! \( -name ".git" -prune \) -a                                     \
    \(                                                                 \
      \( -path "./.config/fish/functions" -o                           \
         -path "./.vim/bundle/neobundle.vim" \)                        \
      -prune -print -o -print \) ); do
  file=${file#./}
  if [[ -d "$file" &&                      \
    "$file" != ".config/fish/functions" && \
    "$file" != ".vim/bundle/neobundle.vim" ]]; then
    run mkdir -pv "$HOME/$file"
  else
    run ln -sfnv "$DOTFILES/$file" "$HOME/$file"
  fi
done
