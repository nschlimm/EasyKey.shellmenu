#!/bin/sh

# all your menu actions here

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

while ${continuemenu:=true}; do
clear
menuInit "Inspecting repositories"
submenuHead "State of working tree and stage (git status)"
menuPunkt a "List which files are staged, unstaged, and untracked" "git status -s"
echo
submenuHead "Information regarding the committed project history (git log)"
menuPunkt b "Display commit history in one line" "git log --oneline"
menuPunkt c "Show which files were altered in commits" "git log --stat"
menuPunkt d "Display patch representing each commit" "git log -p"
menuPunkt e "Search for commits by a particular author" listAuthorCommits
menuPunkt f "Only display commits that include the specified file" listFileCommits
menuPunkt g "Display a full diff of all the changes someone has made to a file" authorDiffFile
menuPunkt h "Display contents of one commit" oneCommit
echo
choice
done
noterminate