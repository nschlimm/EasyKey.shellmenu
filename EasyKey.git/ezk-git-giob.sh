#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$script_dir/../shellmenu.sh"
source "$script_dir/ezk-git-functions.sh"

setActual() {
  actual=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
}

setActual

menuInit "Git object internals"
submenuHead "Usefull commands "
menuItem b "Current HEAD pointer" "git symbolic-ref HEAD"
menuItem c "Inspect current tree" "git cat-file -p ${actual}^{tree}"
menuItem d "Inspect current commit" "git cat-file -p ${actual}^{commit}"
menuItem e "All branches" "tree .git/refs/heads"
menuItem f "All tags" "git fetch --tags && tree .git/refs/tags"
startMenu "setActual"
noterminate