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
    executeCommand "git cat-file -p $cname"
}

showAllGitObjects() {
    # Iterate over each hash
    while read -r hash filename; do
        # Get the type of object for the hash
        obj_type=$(git cat-file -t "$hash")
        
        if [ "$obj_type" = "commit" ]; then
          commit_date=$(git cat-file -p $hash | awk '/^author / {print $5}' | xargs date -r)
        else
          commit_date=""
        fi

        # Output the hash and its corresponding object type
        echo "$hash: $obj_type $filename $commit_date"
    done < <({
               git rev-list --objects --all
               git rev-list --objects -g --no-walk --all
               git rev-list --objects --no-walk \
               $(git fsck --unreachable |
                 grep '^unreachable commit' |
                 cut -d' ' -f3)
             } | sort | uniq | sort -k2)
}

currentObjects() {
  branch=$(git rev-parse --abbrev-ref HEAD)
  importantLog "branch: $branch"
  # Step 2: Get the commit object from the branch
  commit=$(git rev-parse "$branch")
  importantLog "head commit: $commit"
  # Step 3: Get the tree object from the commit object
  tree=$(git cat-file -p "$commit" | awk '/^tree/ {print $2}')
  importantLog "tree: $tree"
  # Step 4: Get all tree and blob objects from the tree object
  blueLog "blobs in tree:"
  git ls-tree -r "$tree"
  blueLog "trees in tree:"
  git ls-tree -d "$tree"
}

contObject() {
  echo "Enter hash:"
  read chash
  [ "$chash" = "" ] && waitonexit && return 
  executeCommand "git cat-file -p $chash"
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
menuItem h "The actuial list of blobs" "git ls-tree -r HEAD"
menuItem i "The actuial list of trees" "git ls-tree HEAD | grep tree"
menuItem j "All GIT objects" showAllGitObjects
menuItem k "Current objects HEAD>BRANCH>COMMIT>OBJECTS" currentObjects
menuItem l "Show contents of object" contObject
startMenu "setActual"
noterminate