#!/bin/bash

###################################
# EasyKey.git utility main script #
###################################

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$script_dir/../shellmenu.sh"
source "$script_dir/ezk-git-functions.sh"

globalClmWidth=35
immediateMode=true

git fetch --all --tags 2> /dev/null

while ${continuemenu:=true}; do
clear
menuInit "Super GIT Home"
echo
submenuHead "Working with remotes:"
menuItemClm a "Gently push current" pushActual b "Set remote origin repo" setRemoteOrigin
menuItemClm e "Set upstream to current" setUpstream f "Administer remotes" adminRemotes
menuItem g "Show repository history" showRepoHisto
echo
submenuHead "Working on local branches:"
menuItemClm k "New local/remote branch checkout" newLocalBranch L "Push local branch to remote" pushLocalBranch
menuItemClm v "Checkout remote branch" coRemoteBranch n "Delete local/remote branch" deleteBranch
menuItemClm o "Merge source to target branch" mergeSourceToTarget p "Show all branches (incl. remote)" showAllBranches
menuItem r "Show branch history" showBranchHisto
echo
submenuHead "Other usefull actions:"
menuItemClm s "Working with diffs" workingDiffs w "Atlassian's view" atlassiansView
menuItem c "Change last commit message" "git commit --amend"
echo
submenuHead "Git admin actions:"
menuItemClm 1 "Show local git config" localGitConfig 2 "Show global git config" globalGitConfig
menuItemClm 3 "Administering aliases" adminAliases 4 "Show .gitignore" gitIgnore
menuItemClm 5 "Git extras" gitExtras 6 "Change Git Passwords" gitPasswort
echo
submenuHead "Shortcuts"
menuItemClm P "Change project" changeProject B "Change branch" changeBranch
menuItem F "Fetch all" fetachAll 
echo
showStatus
choice
done
echo "bye, bye, homie!"
