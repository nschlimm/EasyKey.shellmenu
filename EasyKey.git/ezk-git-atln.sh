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
	# Comment added 
	bash $script_dir/../EasyKey.git/ezk-git-reme.sh
	nowaitonexit
}

cherryPick() {
   git log --all --graph --decorate --oneline --format='%C(bold blue)%h%Creset %s %C(bold green)(%cd)%Creset %an' --date=format:'%Y-%m-%d %H:%M'
   echo "Enter commit you want to pick:"
   read cname
   [ "${cname}" = "" ] && waitonexit && return 
   git branch
   echo "Select target branch:"
   read cbranch
   [ "${cbranch}" = "" ] && waitonexit && return 
   git checkout $cbranch
   git cherry-pick $cname
   echo -n "Cherry picked $cname. Add files to stage(y/n)?" && wait_for_keypress && echo
   [ "${REPLY}" != "y" ] && waitonexit && return 
   git add .
   if [ -f .git/CHERRY_PICK_HEAD ]; then
     git cherry-pick --continue
   else
     echo "No cherry-pick in progress"
   fi
   echo -n "Push changes(y/n)?" && wait_for_keypress && echo
   [ "${REPLY}" != "y" ] && waitonexit && return 
   git push origin $cbranch
}

atlnStatus() {
  echo "Atlassians view on GIT, https://de.atlassian.com/git/tutorials"
}

menuInit "Atlassian's View"
submenuHead "Working on your local repository"
menuItem b "Saving changes" savingChanges
menuItem c "Inspecting a repository" inspectingRepos
menuItem d "Undoing changes" undoingChanges
menuItem e "Cherry pick commit" cherryPick 
startMenu "atlnStatus"
noterminate