#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$script_dir/../shellmenu.sh"
source "$script_dir/ezk-git-functions.sh"

setActual() {
  actual=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
}

allBranches() {
  find .git/refs/heads -type f -exec sh -c 'echo "File: $1"; cat "$1"' _ {} \;
}

allTags() {
  find .git/refs/tags -type f -exec sh -c 'echo "File: $1"; cat "$1"' _ {} \;
}

contCommit() {
	git log --all --graph --decorate --oneline --format='%C(bold blue)%h%Creset %s %C(bold green)(%cd)%Creset %an' --date=format:'%Y-%m-%d %H:%M'
	echo "Enter commit to display:"
	read cname
	[ "${cname}" = "" ] && waitonexit && return 
    executCommand "git cat-file -p $cname"
}

setActual

menuInit "Git object internals"
submenuHead "Usefull commands "
menuItem b "Current HEAD pointer" "git symbolic-ref HEAD"
menuItem c "Inspect current tree object" "git cat-file -p ${actual}^{tree}"
menuItem d "Inspect current commit object" "git cat-file -p ${actual}^{commit}"
menuItem e "Show contents of commit object" contCommit
menuItem f "All branches" allBranches
menuItem g "All tags" allTags
startMenu "setActual"
noterminate