#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$script_dir/../shellmenu.sh"
source "$script_dir/ezk-git-functions.sh"

function listAuthorCommits () {
	executeCommand "git authors --list"
	echo "Enter the author:"
	read author
	executeCommand "git log --graph --pretty=format:'%Cred%h%Creset %ad: %C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --author=$author --date=short"
}

function listFileCommits () {
   selectItem "git ls-files"
   executeCommand "git log --graph --pretty=format:'%Cred%h%Creset %ad: %C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --author=$author --date=short $selected"
}

function authorDiffFile () {
	executeCommand "git authors --list"
	echo "Enter the author:"
	read author
    selectItem "git ls-files"
    executeCommand "git log --author=$author -p $selected"
}

function oneCommit () {
	echo "Commits since [yyyy-mm-dd]:"
	read sincedate
	git log --since="\{${sincedate}\}T00:00:00-00:00" --oneline
	echo "Enter commit:"
	read commit
	git diff $commit^ $commit --name-status
}

menuInit "Inspecting repositories"
submenuHead "State of working tree and stage (git status)"
menuItem a "List which files are staged, unstaged, and untracked" "git status -s"
submenuHead "Information regarding the committed project history (git log)"
menuItem b "Display commit history in one line" "git log --oneline"
menuItem c "Show which files were altered in commits" "git log --stat"
menuItem d "Display patch representing each commit" "git log -p"
menuItem e "Search for commits by a particular author" listAuthorCommits
menuItem f "Only display commits that include the specified file" listFileCommits
menuItem g "Display a full diff of all the changes someone has made to a file" authorDiffFile
menuItem h "Display contents of one commit" oneCommit
startMenu
noterminate