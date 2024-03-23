#!/bin/bash

function revertLastCommit () {
   echo "Enter YES if you want to revert to last commit:"
   read cname
   [ "${cname}" != "YES" ] && waitonexit && return 
   git revert HEAD
}

function clean () {
   git clean -dn
   git clean -n
   echo "Enter YES if you want to delete the shown changes on directory:"
   read cname
   [ "${cname}" != "YES" ] && waitonexit && return 
   git clean -df
   git clean -f
}

function revertToCommit () {
   echo "Last 15 commits"
   git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -n 100
   echo "Enter commit to revert (all changes of that commit will be reverted)"
   read cname
   [ "${cname}" = "" ] && waitonexit && return 
   git revert $cname
}

function resetToCommit () {
   echo "Last 15 commits"
   git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -n 100
   echo "Enter target commit for reset (all commits after the commit will be deleted)"
   read cname
   [ "${cname}" = "" ] && waitonexit && return 
   git reset $cname
}

function resetToCommitHard () {
   echo "Last 15 commits"
   git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -n 100
   echo "Enter target commit for reset (all commits after the commit will be deleted) - YOUR LOCAL WORKING DIR WILL BE OVERWRTITTEN!"
   read cname
   [ "${cname}" = "" ] && waitonexit && return 
   git reset --hard $cname 
}

while ${continuemenu:=true}; do
clear
menuInit "Undoing changes"
coloredLog "   ALWAYS PREFER REVERT   " "$clrPurple" "$clrWhite"
submenuHead "Undoing changes"
menuItem a "Revert last commit - (keep commit history - create new commit)" revertLastCommit
menuItem b "Revert commit - (keep commit history - create new commit)" revertToCommit
menuItem c "(Soft) Reset commit - (delete some commits - keep current working dir)" resetToCommit
menuItem d "(Hard) Reset commit - (delete some commits - overwrite working dir)" resetToCommitHard
menuItem e "Undo local changes (only effects untracked files)" clean

echo
echo "NOTE: if your work with remote repos and already 
      pushed commits that you want to undo -> PREFER REVERT !!"

choice
done
noterminate