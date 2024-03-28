#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$script_dir/../shellmenu.sh"
source "$script_dir/ezk-git-functions.sh"

function changeBlame () {
	git log --pretty=format:'%Cred%h%Creset | %Cgreen%ad%Creset | %s %C(yellow)%d%Creset %C(bold blue)[%an]%Creset %Cgreen(%cr)%Creset' --graph --date=short
	echo "Enter baseline commit:"
	read baseline
    [ "$baseline" = "" ] && waitonexit && return 
	echo "Enter until commit (default HEAD):"
	read untilcommit
    [ "$untilcommit" = "" ] && waitonexit && return 
	executeCommand "git guilt $baseline ${untilcommit:-HEAD}"
}

function removeLatest () {
	echo "How many commits to remove?"
	read ccommit
    [ "$ccommit" = "" ] && waitonexit && return 
	executeCommand "git back $ccommit"
}

function findOut () {
	executeCommand "git authors --list"
	echo "Enter author to check:"
	read author
    [ "$author" = "" ] && waitonexit && return 
	echo "Since (in days, e.g. 2)?"
	read since
    [ "$since" = "" ] && waitonexit && return 
	executeCommand "git standup -a "$author" -d "$since""
}

function obliterate () {
	read -p "This programm completely deletes. Continue (y/n)? " -n 1 -r
	echo
    [ "$REPLY" = "" ] && waitonexit && return 
	if [[ $REPLY =~ [Yy]$ ]]; then
		selectItem "git ls-files"
		read -p "Remove $fname (y/n)? " -n 1 -r
        [ "$REPLY" = "" ] && waitonexit && return 
		echo
		if [[ $REPLY =~ [Yy]$ ]]; then
		   executeCommand "git obliterate $fname"
		fi
	fi
	
}

monthlySummary() {
  git log --oneline --format='%C(auto)%ad %h %d' --date=format:'%Y-%m-%d' | awk '{print substr($1, 1, 7)}' | sort | uniq -c | awk '{print $2, $1}'
}

menuInit "Git extras menu"
submenuHead "Project information"
menuItem a "Project summary in commits" "git summary"
menuItem b "Project summary in lines of code" "git summary --line"
menuItem c "Effort in the project per file" "git effort"
menuItem d "Show all ignore patterns from local and global" "git ignore"
menuItem e "Show information about the repo" "git info"
menuItem f "Generate changelog" "git changelog -a"
menuItem g "Show tree" "git show-tree"
menuItem h "Show activity calendar" "git cal"
menuItem i "Monthly count of commits" monthlySummary
submenuHead "Author information"
menuItem k "List authors" "git authors --list"
menuItem l "Find out what somebody did since ..." findOut
menuItem m "Display change in blame between two revisions" changeBlame
submenuHead "Effect repository actions"
menuItem q "Remove latest commits and add their changes to stage" removeLatest
menuItem r "Completely remove a file from the repository" obliterate
menuItem s "Setup git repository in current dir" "git setup"
startMenu
noterminate
