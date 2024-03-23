#!/bin/sh

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
   echo "Enter date since in [yyyy-mm-dd]:"
   read sincedate
   lastcommitdate=$(git log --pretty=format:'%h %ad' --graph --date=format:"%Y-%m-%d" --since "$sincedate 00:00:00" | cut -f3 -d' ' | tail -1) # the last commit date since the date given
   echo "first commit date equal or after since date: $lastcommitdate"
   commitpriortolast=$(git log --pretty=format:'%h %ad' --graph --date=format:"%Y-%m-%d" | grep "$lastcommitdate" -A 1 | tail -1 | cut -f2 -d' ') # commit before the last commit in period
   echo "next commit date prior since date: $commitpriortolast"
   commitdatepriortolast=$(git log --pretty=format:'%h %ad' --graph --date=format:"%Y-%m-%d" | grep "$lastcommitdate" -A 1 | tail -1 | cut -f3 -d' ') # commit date before the last commit in period
   echo "next commit date prior since date: $commitpriortolast ... on: $commitdatepriortolast"
   newestcommit=$(git log --pretty=format:'%h %ad' --graph --date=format:"%Y-%m-%d" | head -1 | cut -f2 -d' ') # the newest commit in the branch (actual head state)
   echo "latest commit in this branch hstory: $newestcommit"
   newestcommitdate=$(git log --pretty=format:'%h %ad' --graph --date=format:"%Y-%m-%d" | head -1 | cut -f3 -d' ') # the newest commit date
   coloredLog "changes since $sincedate 12 a.m. / midnight: comparing commit $commitpriortolast made on $commitdatepriortolast against $newestcommit (latest commit) made on $newestcommitdate"
   diffDrillDownAdvanced "git diff --name-status $commitpriortolast $newestcommit" "awk '{print \$2}'" "$commitpriortolast" "$newestcommit"
   #git log --oneline | grep --color -E 'Add slack integration to pipeline|$'
   # why git log is so strange: http://stackoverflow.com/questions/14618022/how-does-git-log-since-count why 
   # alternative: git diff 'HEAD@{2017-03-03T00:00:00}' HEAD --name-status | nl
}

git fetch --all
while ${continuemenu:=true}; do
clear
menuInit "Working with diffs"
echo "Note: GIT diff cann compare three locations with each other: the tree (your working directory), the stage, the repository."
submenuHead "Different diff options:"
menuItem a "actual branch        vs. origin/actual branch.      -> local repository vs. remote repository" headHead
menuItem b "actual working dir   vs. actual branch last commit  -> tree vs. local repository" dirHead
menuItem c "actual working dir   vs. other commits              -> tree vs. local repository" treeCommit
menuItem d "commit               vs. commit                     -> local repository vs. local repository" commitCommit
menuItem e "branch               vs. branch                     -> repository vs. repository " branchBranch
echo
submenuHead "Specific diffs:"
menuItem k "Diff since date" diffDate
echo
submenuHead "Other usefull stuff here:"
menuItem h "show commits" showCommits
echo
showStatus
choice
done
noterminate