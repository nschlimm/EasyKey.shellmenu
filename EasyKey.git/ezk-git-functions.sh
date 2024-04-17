#!/bin/bash

function analyzeWorkingDir (){
   wstat=$(git diff HEAD --shortstat) # analyze local dir working status vs. actual checkout
   if [ -z "$wstat" ]; then
      wstat="tracked files clean"
   fi
   untracked=$(git ls-files --others --exclude-standard)
   if [ -z "$untracked" ]; then
      wstat="$wstat (no untracked files present)"
    else
      filescount=$(git ls-files --others --exclude-standard | wc -l)
      wstat="$wstat (WARN: $filescount untracked file(s) present)"
   fi
   echo "> $wstat"
   echo
}

function pushActual() {
  executeCommand "git fetch --all"
  importantLog "Checking your head state"

  # Check if the current branch has an upstream (remote)
  if [ -z "$(git rev-parse --abbrev-ref --symbolic-full-name ${current_branch}@{upstream} 2>/dev/null)" ]; then
     echo "The current branch '"$actual"' doesn't have an upstream branch."
     echo
     echo -n "Do you want to create and attach remot branch (y/n)?" && wait_for_keypress && echo
     [ "$REPLY" != "y" ] && waitonexit && return 
     setUpstream
  fi

  if git status | grep -q "HEAD detached"; then
     redLog "... you seem to be on a detached head state ... can't push ..."
  else
    echo "... your HEAD is attached to '$actual' branch ..."
    mergeChanges
    addAllUntracked
    commitChanges
    pushChanges
  fi
  waitonexit
}

function pushChanges () {
    importantLog "Checking for stuff to push to origin/$actual"
    if git log origin/$actual..$actual --oneline | grep -q ".*"; then
      echo "... found commited updates in $actual waiting for push to origin/$actual ..."
      read -p "Push (y/n)? " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then #push
         executeCommand "git push -u origin $actual"
      fi
    else
      echo "... nothing to push ..."
    fi
}

function addAllUntracked () {
    importantLog "Checking for untracked files in the working tree"
    # check to see if untracked files are in working tree
    if git ls-files --others --exclude-standard | grep -q ".*"; then
      echo "... untracked files found ..."
      executeCommand "git ls-files --others --exclude-standard"
      read -p "Add all (y/n)? " -n 1 -r
      echo    # (optional) move to a new line
      if [[ $REPLY =~ ^[Yy]$ ]]; then
         executeCommand "git add ."
      fi
    else
      echo "... no untracked files present ..."
    fi
}

function mergeChanges () {

    importantLog "Checking for merge requirements from remote origin"

    # Get the name of the current branch
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    # Get the number of commits ahead of the remote branch
    ahead_count=$(git rev-list --count ${current_branch}@{upstream}..${current_branch})
    behind_count=$(git rev-list --count ${current_branch}..${current_branch}@{upstream})

    # Check if the current branch is ahead of the remote branch
    if [ $ahead_count -eq 0 ]; then
        echo "Your current branch '$current_branch' is in sync with origin."
        echo "... nothing to merge ..."
    elif [ $ahead_count -ge 0 ]; then
        echo "Your current branch '$current_branch' is ahead of its remote counterpart by $ahead_count commit(s)."
        echo "... nothing to merge ..."
    elif [ $behind_count -gt 0 ]; then
        echo "Your current branch '$current_branch' is behind of its remote counterpart."
        coloredLog "   MERGE RECOMMENDED   " "$clrPurple" "$clrWhite" && printf "\n\r"
        diffDrillDownAdvanced "git diff --name-status origin/$actual $actual" "awk '{print \$2}'" "origin/$actual" "$actual"
        executeCommand "git diff --name-status origin/$actual $actual"
        read -p "Merge (y/n)? " -n 1 -r
        echo    # (optional) move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]; then
           executeCommand "git merge origin/$actual"
        fi
    fi
}
 
function commitChanges () {
    importantLog "Checking for stuff to commit from the working tree"
    if git status -s -uno| grep -q ".*"; then
      echo "... found updates on tracked files in working tree ..."
      diffDrillDownAdvanced "git status -s -uno" " .*" HEAD
      read -p "Commit the updates (y/n)? " -n 1 -r
      echo    # (optional) move to a new line
      if [[ $REPLY =~ ^[Yy]$ ]]; then
           read -p "Enter commit message:" cmsg
           executeCommand "git commit -am '${cmsg}'" # stage and commit all tracked filess
      fi
    else
      echo "... nothing to commit ..."
    fi
}

function adminRemotes() {
              echo
            echo "Administer remotes:"
            echo "a. Show remotes"
            echo "b. Add remote"
            echo "c. Inspect remote"
            echo
            read -p "Make your choice: " -n 1 -r subreply
            echo

            case $subreply in
                "a")
                   echo $'\nKnown remotes:'
                   git remote -v
                ;;
                "b")
                    echo "What is the adress?"
                    read adress
                    [ "${adress}" = "" ] && waitonexit && return 
                    echo "Type an alias for this remote?"
                    read ralias
                    [ "${ralias}" = "" ] && waitonexit && return 
                    git remote add $ralias $adress
                ;;
                "c")
                    git remote -v
                    echo "Name of the remote to inspect"
                    read rname
                    [ "${rname}" = "" ] && waitonexit && return 
                    git remote show $rname
                ;;
            esac

}

function showRepoHisto() {
   git reflog
   echo && echo "To go back to a commit type: git checkout HEAD@{1}. Then create a branch from there." && echo
}

function cloneRemote() {
            echo "Where?"
            . ~/Personal/fl.sh
            pwd
            echo "Remote repository url:"
            read url
            git clone $url
}

function newLocalBranch() {
    echo "Name des neuen Branch?"
    read branchname
    [ "${branchname}" = "" ] && waitonexit && return 
    git branch $branchname 
    git checkout $branchname
    read -p "Set upstream? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
        then
           git push --set-upstream origin $branchname
    fi      
}

function rollBackLast() {
            read -p "This rolls back one commit. Continue? [y/n]" -n 1 -r
            if [[ $REPLY =~ ^[Yy]$ ]]
                then
                  git reset HEAD~1
            fi
            git status -s
            read -p "Delete file modifications in local working dir? " -n 1 -r
            echo    # (optional) move to a new line
            if [[ $REPLY =~ ^[Yy]$ ]]
                then
                    git reset HEAD --hard
            fi      
}

function deleteBranch() {
  git branch
  echo "Which branch to delete?"
  read dbranch
  [ "${dbranch}" = "" ] && waitonexit && return 
  git branch -d $dbranch
  read -p "Delete remote [y/n]? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
    then
       git push origin --delete $dbranch
  fi 
}

function mergeSourceToTarget(){
    git branch --all
    echo "Enter merge target branch"
    read target
    [ "${target}" = "" ] && waitonexit && return 
    echo "Enter merge source branch"
    read bsource
    [ "${bsource}" = "" ] && waitonexit && return 
    git checkout $target
    git merge $bsource
}

function showAllBranches () {
   git branch --all
}

function showBranchHisto(){
   git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
}

function setUpstream() {
  read -p "Do you wish to connect origin '${actual}' to local '${actual}'? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
    then
      git push --set-upstream origin $actual
  fi 
}

function localGitConfig() {
  vim .git/config
}

function globalGitConfig() {
  vim ~/.gitconfig
}

function gitIgnore() {
            vim .gitignore
}

function undoReset () {
  git reflog --date=iso
  echo "Choose commit to reset:"
  read cname
  if [ -z "$cname" ]; then
    echo "No commit entered!"
  else
    git reset $cname
  fi
}

function interactiveStage () {
   git add -i
}

function changeBranch () {
   git branch --all
   echo "Which branch?"
   read bname
   [ "${bname}" = "" ] && waitonexit && return 
   git checkout $bname
}

function fetchAll () {
   git fetch --prune
   git fetch --all
}

# submenus

function workingDiffs() {
  unset form
  bash $script_dir/../EasyKey.git/ezk-git-diff.sh
  nowaitonexit
}

function atlassiansView() {
  bash $script_dir/../EasyKey.git/ezk-git-atln.sh
  nowaitonexit
}

function changeProject () {
  source $script_dir/../EasyKey.git/ezk-git-loca.sh
  noterminate
  nowaitonexit
}

function gitExtras () {
  bash $script_dir/../EasyKey.git/ezk-git-extras.sh
  nowaitonexit
}

objectInternals() {
  bash $script_dir/../EasyKey.git/ezk-git-giob.sh
  nowaitonexit
}

function reset () {
  executeCommand "git reset"
}

function commitAll () {
    executeCommand "git commit -a"
}

function assumeUnchanged () {
    git ls-files
    echo "Which file?"
    read filename
    [ "${filename}" = "" ] && waitonexit && return 
    executeCommand "git update-index --assume-unchanged $filename"
}

function unAssumeUnchanged () {
    git ls-files -v | grep '^[[:lower:]]'
    echo "Which file?"
    read filename
    executeCommand "git update-index --no-assume-unchanged $filename"
}

function coRemoteBranch () {
       git branch -r
       echo "Which remote branch?"
       read bname
       [ "${bname}" = "" ] && waitonexit && return 
       git checkout --track $bname 
}

function setRemoteOrigin() {
   echo "Enter remot origin address:"
   read originaddress
   [ "${originaddress}" = "" ] && waitonexit && return 
   executeCommand "git remote set-url origin $originaddress"
}

newStatus() {
   actual=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
   git status -s 
}

function showStatus () {
  importantLog $(pwd | grep -o "[^/]*$")
  actual=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  importantLog $actual 
  git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s' --abbrev-commit -n 1
  analyzeWorkingDir
  git remote -v
}

diffDrillDownAdvanced () { 
  listkommando="$1"
  regexp="$2"
  if $listkommando | grep -q ".*"; then
   while true; do
        importantLog "Drill down into file logcommanddiff: $listkommando"
        selectItem "$listkommando" "$regexp"
        if [[ $fname = "" ]]; then
          break
        fi
        if [ $# -eq 3 ]
          then
             kommando="git difftool $3 -- $fname"
             executeCommand "$kommando"
        fi
        if [ $# -eq 4 ]
          then
             kommando="git difftool $3 $4 -- $fname"
             executeCommand "$kommando"
        fi
   done
  fi
}

repoSize() {
   executeCommand "git gc"
   executeCommand "git count-objects -vH"
   executeCommand "git rev-list --objects --all | grep -f <(git verify-pack -v  .git/objects/pack/*.idx| sort -k 3 -n | cut -f 1 -d ' ' | tail -10)"
   echo "Enter file pattern to REMOVE in repo history (e.g. *.jar or full qualified filename or */folder/*):"
   read filePattern
   [ "${filePattern}" = "" ] && waitonexit && return 
   executeCommand "git filter-repo --path-glob '${filePattern}' --invert-paths --force"
   executeCommand "git reflog expire --expire=now --all"
   executeCommand "git gc --prune=now"
   executeCommand "git count-objects -vH"
}

function settingUp () {
    bash $script_dir/../EasyKey.git/ezk-git-atsu.sh
    nowaitonexit
}

ammendCommit() {
    behind_count=$(git rev-list --count ${current_branch}..${current_branch}@{upstream})
    if [ $behind_count -gt 0 ]; then
        echo "Your branch is behind remote branch! Update first using git pull."
        return
    fi
    coloredLog "   BE CAREFULL IN SHARED BRANCHES !   " "$clrPurple" "$clrWhite" && printf "\n\r"
    echo
    echo "If you do this in shared branches, and you have pushed the commits to remote repo already,"
    echo "some developers might have the commit object your going to change as predecessor to their"
    echo "commits. Actually you will replace that object with a new one. This changes the commit "
    echo "history which can result in conflicts."
    echo 
    echo "If you are the only developer working in that branch, the change is NOT critical."
    echo 
    echo -n "Change some commit messages (y/n)?" && wait_for_keypress && echo
    [ "${REPLY}" != "y" ] && waitonexit && return 
    git rebase -i HEAD~1
    if [ $? -ne 0 ]; then
        importantLog "Rebase failed"
    else
        importantLog "Rebase successful"
        executeCommand "git push --force origin $actual"
    fi
}

prettyLog() {
  git log --all --graph --decorate --oneline --format='%C(auto)%ad %h %d %C(bold blue)%an%Creset %s %C(bold red)%D' --date=format:'%Y-%m-%d %H:%M'
}

allBranches() {
  git branch -r | grep -v '\->' | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
  executeCommand "git fetch --all"
  executeCommand "git pull --all"
}