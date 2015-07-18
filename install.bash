#!/usr/bin/env bash

set -e

# utility function

run() {
  if [[ -n "$DEBUG" ]]; then
    echo "$@"
  else
    eval "$@"
  fi
}

# actions

nop() {
  if [[ -n "$DEBUG" ]]; then
    echo nop "$@"
  fi
}

link() {
  if [[ -L "$2" ]]; then
    if [[ "$1" == "$(readlink "$2")" ]]; then
      return 0
    fi
  fi
  run ln -vsf "$1" "$2"
}

make-dir() {
  run mkdir -vp "$2"
}

remove-file() {
  run rm -vf "$2"
}

remove-dir() {
  run rmdir -v "$2" || return 0
}

# change directory into top of dotfiles directory

cd-dotfiles-top() {
  if [[ -f ".dotfiles" ]]; then
    DOTFILES="$PWD"
  else
    if ! cd .. 2>/dev/null; then
      echo "DOTFILES not found"
      exit 1
    fi
    cd-dotfiles-top
  fi
}

# loop and link dotfiles

link-dotfiles() {
  local dir="$1" base path

  for base in *; do
    if [[ -z "$dir" ]]; then
      path="$base"
    else
      path="$dir/$base"
    fi

    # ignore
    if is-ignore "$path"; then
      continue
    fi

    # directory
    if [[ -d "$base" ]]; then
      if is-break-dir "$path"; then
        eval $DOTFILES_LINK "$DOTFILES/$path" "$(fix-path "$path")"
      else
        eval $DOTFILES_ENTER_DIR "$DOTFILES/$path" "$(fix-path-dir "$path")"
        pushd "$DOTFILES/$path" >/dev/null
        link-dotfiles "$path"
        popd >/dev/null
        eval $DOTFILES_LEAVE_DIR "$DOTFILES/$path" "$(fix-path-dir "$path")"
      fi

    # otherelse (file or symbolic link...)
    else
      eval $DOTFILES_LINK "$DOTFILES/$path" "$(fix-path "$path")"
    fi
  done
}

DOTFILES_IGNORE=()
DOTFILES_BREAK_DIR=()
DOTFILES_FIX_DIR_FROM=()
DOTFILES_FIX_DIR_TO=()
DOTFILES_FIX_FILE_FROM=()
DOTFILES_FIX_FILE_TO=()

is-ignore() {
  local path="$1" ignore
  for ignore in "${DOTFILES_IGNORE[@]}"; do
    [[ "$path" == "$ignore" ]] && return 0
  done
  return 1
}

is-break-dir() {
  local path="$1" break_dir
  for break_dir in "${DOTFILES_BREAK_DIR[@]}"; do
    [[ "$path" == "$break_dir" ]] && return 0
  done
  return 1
}

fix-path-dir() {
  local dir="$1"

  for i in $(seq 0 $[${#DOTFILES_FIX_DIR_FROM[@]} - 1]); do
    if [[ "$dir" == "${DOTFILES_FIX_DIR_FROM[$i]}" ]]; then
      echo "$HOME/${DOTFILES_FIX_DIR_TO[$i]}"
      return 0
    fi
  done

  echo "$HOME/.$dir"
}

fix-path() {
  local path="$1" dir="$(dirname "$path")"

  for i in $(seq 0 $[${#DOTFILES_FIX_DIR_FROM[@]} - 1]); do
    if [[ "$dir" == "${DOTFILES_FIX_DIR_FROM[$i]}" ]]; then
      echo "$HOME/${DOTFILES_FIX_DIR_TO[$i]}/$(basename "$path")"
      return 0
    fi
  done

  for i in $(seq 0 $[${#DOTFILES_FIX_FILE_FROM[@]} - 1]); do
    if [[ "$path" == "${DOTFILES_FIX_FILE_FROM[$i]}" ]]; then
      echo "$HOME/${DOTFILES_FIX_FILE_TO[$i]}"
      return 0
    fi
  done

  echo "$HOME/.$path"
}
# for .dotfiles DSL

ignore() {
  DOTFILES_IGNORE=("${DOTFILES_IGNORE[@]}" "$@")
}

break-dir() {
  DOTFILES_BREAK_DIR=("${DOTFILES_BREAK_DIR[@]}" "$@")
}

fix-dir() {
  DOTFILES_FIX_DIR_FROM=("${DOTFILES_FIX_DIR[@]}" "$1")
  DOTFILES_FIX_DIR_TO=("${DOTFILES_FIX_TO[@]}" "$2")
}

fix-file() {
  DOTFILES_FIX_FILE_FROM=("${DOTFILES_FIX_FILE[@]}" "$1")
  DOTFILES_FIX_FILE_TO=("${DOTFILES_FIX_TO[@]}" "$2")
}

if [[ -z "$DOTFILES" ]]; then
  cd-dotfiles-top
else
  cd "$DOTFILES"
fi

source "$DOTFILES/.dotfiles"

DOTFILES_LINK="link"
DOTFILES_ENTER_DIR="make-dir"
DOTFILES_LEAVE_DIR="nop"

if [[ "$1" == "-d" ]]; then
  # delete
  DOTFILES_LINK="remove-file"
  DOTFILES_ENTER_DIR="nop"
  DOTFILES_LEAVE_DIR="remove-dir"
elif [[ "$1" == "-t" ]]; then
  # trace
  DOTFILES_LINK="echo \"link \" ::"
  DOTFILES_ENTER_DIR="echo enter ::"
  DOTFILES_LEAVE_DIR="echo leave ::"
fi

link-dotfiles ""
