#!/bin/sh

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

while ${continuemenu:=true}; do
clear
menuInit "Saving changes"
submenuHead "Adding changes to stage:"
menuPunkt a "Git add all gently" addAllGently
menuPunkt b "Git interactive staging session" interactiveStage
menuPunkt c "Git interactive staging detail session" interStage
echo
submenuHead "Commit changes:"
menuPunkt d "Commit staged snapshot - vim (stage -> archive)" commitStagedSnapshot
menuPunkt f "Commit all changes of tracked files - vim (tree -> stage -> archive)" commitChangesVim
menuPunkt g "Commit all changes of tracked files - read (tree -> stage -> archive)" commitChanges
echo
submenuHead "Stash current changes:"
menuPunkt h "Stash current changes" stash
menuPunkt i "Reapply stash to current directory (pop - deletes stash)" stashPop
menuPunkt j "Reapply stash to current directory (apply - leaves stash alive)" stashApply
menuPunkt k "Stash current changes - include untracked" stashAllIncludeUntracked
menuPunkt l "Stash current changes - include all untracked and ignored" stashAll
echo
submenuHead "Managing multiple stashes:"
menuPunkt m "List stashes" stashList
menuPunkt n "Stash with message" stashWithMessage
menuPunkt o "Reapply stash to current directory from stash list (pop)" stashPopFromList
menuPunkt p "Reapply stash to current directory from stash list (apply)" stashApplyFromList
echo
submenuHead "Clean up stashes:"
menuPunkt r "Delete all stashes" stashDeleteAll
menuPunkt s "Delete specific stash" stashDeleteSpecific
echo
submenuHead "Other stash stuff:"
menuPunkt t "View summary of a stash (stash state vs. original parent commit)" stashSummary
menuPunkt u "View diff of a stash (stash state vs. original parent commit)" stashDiff
menuPunkt v "Stash single files" stashSingle
menuPunkt w "Create branch from stash" stashBranch
menuPunkt x "Inspect stashes" inspectStash
echo
submenuHead "Ignoring files:"
menuPunkt y "Ignore menu" ignoreMenu
echo
showStatus
choice
done
noterminate