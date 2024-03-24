#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$script_dir/../shellmenu.sh"
source "$script_dir/ezk-git-functions.sh"

function interStage () {
	git add -p
}

function addAllGently () {
  if git ls-files --others --exclude-standard | grep -q ".*"; then
     echo "... untracked files found ..."
     git ls-files --others --exclude-standard
     read -p "Add all (y/n)? " -n 1 -r
     echo    # (optional) move to a new line
     if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add .
     fi
  fi
}

function commitAllChanges () {
  executeCommand "git commit -a"
}

function interactiveStage () {
   executeCommand "git add -i"
}

function commitStagedSnapshot () {
	executeCommand "git commit"
}

function commitChangesVim () {
	executeCommand "git commit -a"
}

function stashAll () {
	executeCommand "git stash"	
}

function stashPop () {
	executeCommand "git stash pop"
}

function stashApply () {
	executeCommand "git stash apply"
}

function stashAllIncludeUntracked () {
	executeCommand "git stash --include-untracked"	
}

function stashAll () {
	executeCommand "git stash --include-untracked --all"	
}

function stashList () {
	executeCommand "git stash list"	
}

function stashWithMessage () {
	echo "Enter save message for stash:"
	read message
	executeCommand "git stash save $message"	
}

function stashPopFromList () {
	executeCommand "git stash list"
	echo "Enter stash identifier:"
	read identifier
	executeCommand "git stash pop $identifier"
}

function stashApplyFromList () {
	executeCommand "git stash list"
	echo "Enter stash identifier:"
	read identifier
	executeCommand "git stash apply $identifier"
}

function stashSummary () {
	executeCommand "git stash list"
	echo "Enter stash identifier: [stash@{0}]"
	read identifier
	executeCommand "git stash show $identifier"
}

function stashDiff () {
	executeCommand "git stash list"
	echo "Enter stash identifier: [stash@{0}]"
	read identifier
	executeCommand "git stash show $identifier -p --color | diff-so-fancy"
}

function stashSingle () {
	executeCommand "gut stash -p"
}

function stashBranch () {
	executeCommand "git stash list"
	echo "Enter stash identifier: [stash@{0}]"
	read identifier
	echo "Enter branch name:"
	read bname
	executeCommand "git stash branch $bname ${identifier:=stash@{0}}"
}

function stashDeleteAll () {
	read -p "Delete all stashes (y/n)? " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
	  executeCommand "git stash clear"
	fi
	
}

function stashDeleteSpecific () {
	executeCommand "git stash list"
	echo "Enter stash identifier to DELETE: [stash@{0}]"
	read identifier
	executeCommand "git stash drop $identifier"
}

function inspectStash () {
	executeCommand "git stash list"
	echo "Enter stash identifier to inspect:"
	read identifier
	executeCommand "git log --oneline --graph ${identifier:-stash@{0}} -n 15"
}

function ignoreMenu () {
	. $supergithome/atIgnore.sh
	nowaitonexit
}

menuInit "Saving changes"
submenuHead "Adding changes to stage:"
menuItem a "Git add all gently" addAllGently
menuItem b "Git interactive staging session" interactiveStage
menuItem c "Git interactive staging detail session" interStage
submenuHead "Commit changes:"
menuItem d "Commit staged snapshot - vim (stage -> archive)" commitStagedSnapshot
menuItem f "Commit all changes of tracked files - vim (tree -> stage -> archive)" commitChangesVim
menuItem g "Commit all changes of tracked files - read (tree -> stage -> archive)" commitChanges
submenuHead "Stash current changes:"
menuItem h "Stash current changes" stash
menuItem i "Reapply stash to current directory (pop - deletes stash)" stashPop
menuItem j "Reapply stash to current directory (apply - leaves stash alive)" stashApply
menuItem k "Stash current changes - include untracked" stashAllIncludeUntracked
menuItem l "Stash current changes - include all untracked and ignored" stashAll
submenuHead "Managing multiple stashes:"
menuItem m "List stashes" stashList
menuItem n "Stash with message" stashWithMessage
menuItem o "Reapply stash to current directory from stash list (pop)" stashPopFromList
menuItem p "Reapply stash to current directory from stash list (apply)" stashApplyFromList
submenuHead "Clean up stashes:"
menuItem r "Delete all stashes" stashDeleteAll
menuItem s "Delete specific stash" stashDeleteSpecific
submenuHead "Other stash stuff:"
menuItem t "View summary of a stash (stash state vs. original parent commit)" stashSummary
menuItem u "View diff of a stash (stash state vs. original parent commit)" stashDiff
menuItem v "Stash single files" stashSingle
menuItem w "Create branch from stash" stashBranch
menuItem x "Inspect stashes" inspectStash
submenuHead "Ignoring files:"
menuItem y "Ignore menu" ignoreMenu
startMenu
noterminate