#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$script_dir/../shellmenu.sh"
source "$script_dir/ezk-git-functions.sh"

function numberedList () {
  kommando="$1"

}

function headHead () {
     importantLog "Comparing $actual HEAD to $actual/origin HEAD"
     if git status | grep "Your branch is behind"; then
       diffDrillDownAdvanced "git diff --name-status $actual origin/$actual" "awk '{print \$2}'" "$actual" "origin/$actual"
     fi
     if git status | grep "Your branch is ahead"; then
       diffDrillDownAdvanced "git diff --name-status origin/$actual $actual" "awk '{print \$2}'" "origin/$actual" "$actual"
     fi
}

function dirHead () {
   importantLog "Comparing working tree to HEAD"
   diffDrillDownAdvanced "git diff --color --name-status HEAD" "awk '{print \$2}'" "HEAD"
}

function treeCommit () {
   echo "Last 15 commits"
   git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -n 100
   echo "Enter commit name"
   read cname
   diffDrillDownAdvanced "git diff --name-status $cname" "awk '{print \$2}'" "$cname"
}

function treeStage () {
   commit=$(git show --oneline -s | grep -o "^[a-z0-9]*")
   diffDrillDownAdvanced "git diff --name-status $commit" "awk '{print \$2}'" "$commit"	
}

function commitCommit () {
   echo "Last 15 commits"
   git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -n 100
   echo "(a) Enter 'baseline' commit name"
   read cnamea
   echo "(b) Enter second commit name"
   read cnameb
   diffDrillDownAdvanced "git diff --name-status $cnamea $cnameb" "awk '{print \$2}'" "$cnamea" "$cnameb"
}

function branchBranch () {
   echo "Branches"
   git branch --all
   echo "(a) Enter baseline branch name:"
   read cnamea
   echo "(b) Enter second branch name to compare:"
   read cnameb
   diffDrillDownAdvanced "git diff --name-status $cnamea $cnameb" "awk '{print \$2}'" "$cnamea" "$cnameb"	
}

function actualHeadbranchHead () {
    echo "Branches"
    git branch --all
    echo "Enter branch name to compare against $actual head"
    read cnamea
    diffDrillDownAdvanced "git diff --name-status $actual $cnamea" "awk '{print \$2}'" "$actual" "$cnamea"  
}

function showCommits () {
    echo "How many commits?"
    read hmany
    git log --graph --pretty=format:'%Cred%h%Creset %ad: %C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -n ${hmany:-100} --date=iso
}

function diffDate () {
   echo "Enter date since in [yyyy-mm-dd hh:mm:ss]:"
   read sincedate
   [ "${sincedate}" = "" ] && waitonexit && return 
   sincedate=$(echo "$sincedate" | cut -d' ' -f1)
   sincetime=$(echo "$sincedate" | cut -d' ' -f2)
   newestcommit=$(git log --pretty=format:'%h %ad' --date=format:"%Y-%m-%d %H:%M:%S" --since "2024-03-20 12:00:00" | head -1 | cut -d' ' -f1)
   thatcommit=$(git log --pretty=format:'%h %ad' --date=format:"%Y-%m-%d %H:%M:%S" --since "2024-03-20 12:00:00" | tail -1 | cut -d' ' -f1)
   diffDrillDownAdvanced "git diff --name-status $newestcommit $thatcommit" "awk '{print \$2}'" "$commitpriortolast" "$newestcommit"
   #git log --oneline | grep --color -E 'Add slack integration to pipeline|$'
   # why git log is so strange: http://stackoverflow.com/questions/14618022/how-does-git-log-since-count why 
   # alternative: git diff 'HEAD@{2017-03-03T00:00:00}' HEAD --name-status | nl
}

diffStatus() {
  showStatus
  echo
  echo "Note: GIT diff cann compare four locations with each other: "
  echo "      your working directory, the stage, the repository."
  echo
  coloredLog "┌────────┐    ┌────────┐    ┌────────┐    ┌────────┐" "$clrPurple" "$clrBlack" && printf "\n\r"
  coloredLog "│        │    │        │    │        │    │        │" "$clrPurple" "$clrBlack" && printf "\n\r"
  coloredLog "│        │ -> │        │ -> │        │ -> │        │" "$clrPurple" "$clrBlack" && printf "\n\r"
  coloredLog "└────────┘    └────────┘    └────────┘    └────────┘" "$clrPurple" "$clrBlack" && printf "\n\r"
  coloredLog " work dir       stage       local repo    remote repo" "$clrWhite" "$clrBlack" && printf "\n\r"
}

git fetch --all
menuInit "Working with diffs"
  submenuHead "Different diff options:"
    menuItem a "actual branch        vs. origin/actual branch" headHead
    menuItem b "actual working dir   vs. actual branch last commit" dirHead
    menuItem c "actual working dir   vs. other commits" treeCommit
    menuItem d "commit               vs. commit" commitCommit
    menuItem e "branch               vs. branch" branchBranch
  submenuHead "Specific diffs:"
    menuItem k "Diff since date" diffDate
  submenuHead "Other usefull stuff here:"
    menuItem h "show commits" showCommits
startMenu "diffStatus"
noterminate