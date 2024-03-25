#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$script_dir/../shellmenu.sh"
source "$script_dir/ezk-git-functions.sh"

function savingChanges () {
	bash $script_dir/../EasyKey.git/ezk-git-atsc.sh
    nowaitonexit
}

function inspectingRepos () {
	bash $script_dir/../EasyKey.git/ezk-git-atis.sh
	nowaitonexit
}

function undoingChanges () {
	bash $script_dir/../EasyKey.git/ezk-git-atuc.sh
	nowaitonexit
}

function mergeRebase () {
	bash $script_dir/../EasyKey.git/ezk-git-reme.sh
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

atlnStatus() {
  echo "Atlassians view on GIT, https://de.atlassian.com/git/tutorials"
}

checkoutAndBranch(){
   echo "Last 15 commits"
   git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -n 100
   echo "Enter commit you want to checkout:"
   read cname
   [ "${cname}" = "" ] && waitonexit && return 
   executeCommand "git checkout $cname"
   echo "Enter new branch name:"
   read cbranch
   [ "${cbranch}" = "" ] && waitonexit && return 
   executeCommand "git checkout -b $cbranch"
}

menuInit "Atlassian's View"
submenuHead "Working on your local repository"
menuItem b "Saving changes" savingChanges
menuItem c "Inspecting a repository" inspectingRepos
menuItem d "Undoing changes" undoingChanges
menuItem e "Cherry pick commit" cherryPick 
menuItem f "Checkout commit and branch" checkoutAndBranch 
startMenu "atlnStatus"
noterminate