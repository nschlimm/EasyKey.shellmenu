#!/bin/sh

# submenus

function settingUp () {
	source $supergithome/atSettingUp.sh
    nowaitonexit
}

function savingChanges () {
	source $supergithome/atSaveChanges.sh
    nowaitonexit
}

function inspectingRepos () {
	source $supergithome/inspRepo.sh
	nowaitonexit
}

function undoingChanges () {
	source $supergithome/atUndoingChanges.sh
	nowaitonexit
}

while ${continuemenu:=true}; do
clear
menuInit "Atlassian's View"
echo "Atlassians view on GIT, https://de.atlassian.com/git/tutorials"
echo 
submenuHead "Working on your local repository"
menuItem a "Setting up a repository" settingUp
menuItem b "Saving changes" savingChanges
menuItem c "Inspecting a repository" inspectingRepos
menuItem d "Undoing changes" undoingChanges
menuItem e "Rewriting history" 
echo
submenuHead "Collaborating with your homies"
menuItem i "Syncing" 
menuItem k "Making a pull request" 
menuItem l "Using branches" 
echo
submenuHead "Advanced stuff"
menuItem n "Merging vs. Rebasing" 
menuItem o "Reset, checkout and revert" 
menuItem p "Advanced Git log" 
menuItem q "Git Hooks" 
menuItem r "Refs and the Reflog" 
menuItem s "Git LFS" 
echo
showStatus
choice
done
noterminate