#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$script_dir/../shellmenu.sh"
source "$script_dir/ezk-git-functions.sh"

function atLocalGit () {

	pwd
	echo -n "Do you want to create a repository in current directory (y/n)? " && wait_for_keypress && echo
   if [[ $REPLY =~ ^[Yy]$ ]]; then #push
   	executeCommand "git init"
   fi

}

function atLocalGitWithDir () {
	pwd
	echo "Enter the target directory (absolute or relative position):"
	read directory
	[ "${directory}" = "" ] && waitonexit && return 
	start=${directory:0:1}
	echo -n "Do you want to create a repository in that directory '$directory' (y/n)? " && wait_for_keypress && echo
   if [[ $REPLY =~ ^[Yy]$ ]]; then #push
   	executeCommand "git init $directory"
   fi
}

function atLocalGitBare () {
	pwd
	echo "Enter the target directory name (absolute or relative position, e.g. my-repo.git):"
	read directory
	[ "${directory}" = "" ] && waitonexit && return 
	start=${directory:0:1}
	echo -n "Do you want to create a repository in that directory '$directory' (y/n)? " && wait_for_keypress && echo
   if [[ $REPLY =~ ^[Yy]$ ]]; then #push
   	executeCommand "git init --bare $directory"
   fi
}

function cloneRemote () {
     pwd
     echo "Remote repository url:"
     read url
     [ "${url}" = "" ] && waitonexit && return 
     git clone $url
}

function defineAuthor () {
	echo "Enter author name:"
	read aname
	[ "${aname}" = "" ] && waitonexit && return 
	git config --global user.name $aname
	echo "Ente email:"
	read email
	[ "${email}" = "" ] && waitonexit && return 
	git config --global user.email $email
}

function textEditor () {
	echo "Enter text editor name (the command how you call it in the shell):"
	read editor
	[ "${editor}" = "" ] && waitonexit && return 
   git config --system core.editor $editor
}

function openGlobalConfig () {
   git config --global --edit
}

function openSystemConfig () {
   git config --system --edit
}

function openLocalConfig () {
   git config --local --edit
}

function defineMergeTool () {
	echo "Enter merge tool name (e.g. vimdiff):"
	read editor
	[ "${editor}" = "" ] && waitonexit && return 
   git config --global merge.tool $editor
   git config --global diff.tool $editor
}

function adminAliases() {
    echo $'\nActual aliases:'
    git config --get-regexp alias
    read -p "Add or delete aliases (a/d)? " -n 1 -r
    [ "${REPLY}" = "" ] && waitonexit && return 
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[a]$ ]]
        then
            echo "Which command?"
            read bcommand
            [ "${bcommand}" = "" ] && waitonexit && return 
            echo "Define alias:"
            read calias
            [ "${calias}" = "" ] && waitonexit && return 
            git config --global alias.$calias $bcommand
            echo "Alias $calias create for $bcommand!"
        else
            echo "Which alias to delete:"
            read calias
            [ "${calias}" = "" ] && waitonexit && return 
            git config --global --unset alias.$calias
    fi      
}

menuInit "Repositories"
submenuHead "Setting up repositories"
menuItem a "Transform the current directory into a git repository" atLocalGit
menuItem b "Setting up a git repository in a directory" atLocalGitWithDir
menuItem c "Setting up a shared git repository in a directory" atLocalGitBare
menuItem d "Clone a remote repository" cloneRemote
submenuHead "Configure repositories:"
menuItem e "Define the author name and email to be used for all commits" defineAuthor
menuItem f "Administering aliases" adminAliases
menuItem g "Define the text editor used by commands" textEditor
menuItem h "Define merge/diff tool" defineMergeTool
menuItem i "Open global config" openGlobalConfig
menuItem j "Open system config" openSystemConfig
menuItem k "Open local config" openLocalConfig
startMenu
noterminate
noterminate