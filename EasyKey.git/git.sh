#!/bin/bash

###################################
# EasyKey.git utility main script #
###################################

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$script_dir/../shellmenu.sh"
source "$script_dir/ezk-git-functions.sh"

globalClmWidth=35
git fetch --all --tags 2> /dev/null
menuInit "EasyKey.git"
  submenuHead "Working with remotes "
    menuItemClm a "Gently push current" pushActual b "Set remote origin repo" setRemoteOrigin
    menuItemClm e "Set upstream to current" setUpstream f "Administer remotes" adminRemotes
  submenuHead "Working on local branches "
    menuItemClm r "Show branch history" showBranchHisto g "Show reflog" showRepoHisto
    menuItemClm l "Show all commits log" prettyLog p "Show all branches (incl. remote)" showAllBranches
    menuItemClm v "Checkout remote branch" coRemoteBranch n "Delete local/remote branch" deleteBranch
    menuItemClm k "New local/remote branch checkout" newLocalBranch c "Change commit messages" ammendCommit 
    menuItemClm o "Merge source to target branch" mergeSourceToTarget z "Get all remote branches" allBranches
  submenuHead "Other usefull actions "
    menuItemClm s "Working with diffs" workingDiffs w "Working with commits" atlassiansView
    menuItemClm y "Setting up repositories" settingUp 5 "Git extras" gitExtras
    menuItem 9 "GIT object internals" objectInternals
  submenuHead "Git admin actions "
    menuItemClm 1 "Show local git config" localGitConfig 2 "Show global git config" globalGitConfig
    menuItemClm 3 "Administering aliases" adminAliases 4 "Show .gitignore" gitIgnore
    menuItem x "Descrease repo size" repoSize
  submenuHead "Shortcuts "
    menuItemClm P "Change project" changeProject B "Change branch" changeBranch
    menuItem F "Fetch all" fetchAll 
startMenu "showStatus"
echo "bye, bye, homie!"
