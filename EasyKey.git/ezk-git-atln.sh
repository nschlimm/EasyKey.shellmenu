#!/bin/sh

# submenus

function savingChanges () {
	source $script_dir/../EasyKey.git/ezk-git-atsc.sh
    nowaitonexit
}

function inspectingRepos () {
	source $script_dir/../EasyKey.git/ezk-git-atis.sh
	nowaitonexit
}

function undoingChanges () {
	source $script_dir/../EasyKey.git/ezk-git-atuc.sh
	nowaitonexit
}

function mergeRebase () {
	source $script_dir/../EasyKey.git/ezk-git-reme.sh
	nowaitonexit
}

cherryPick() {
   echo "Last 15 commits"
   git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -n 100
   echo "Enter commit you want to pick:"
   read cname
   [ "${cname}" = "" ] && waitonexit && return 
   git cherry-pick "$cname" 
}

while ${continuemenu:=true}; do
clear
menuInit "Atlassian's View"
echo "Atlassians view on GIT, https://de.atlassian.com/git/tutorials"
echo 
submenuHead "Working on your local repository"
menuItem b "Saving changes" savingChanges
menuItem c "Inspecting a repository" inspectingRepos
menuItem d "Undoing changes" undoingChanges
menuItem e "Cherry pick commit" cherryPick 
echo
showStatus
choice
done
noterminate