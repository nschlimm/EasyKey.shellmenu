#!/bin/sh

function atLocalGit () {

	pwd
	gentlyCommandNY "Do you want to create a repository in current directory (y/n)?" "git init"

}

function atLocalGitWithDir () {
	pwd
	echo "Enter the target directory (absolute or relative position):"
	read directory
	start=${directory:0:1}
	if [ "$start" == "/" ]; then
		breakOnNo "You entered an absolut path, continue? (y/n)? "
    fi
    gentlyCommandNY "Do you want to create a directory and repository in ${directory} (y/n)?" "git init $directory"
}

function atLocalGitBare () {
	pwd
	echo "Enter the target directory name (absolute or relative position, e.g. my-repo.git):"
	read directory
	start=${directory:0:1}
	if [ "$start" == "/" ]; then
		breakOnNo "You entered an absolut path, continue? (y/n)? "
    fi
    gentlyCommandNY "Do you want to create a shared directory and repository in ${directory} (y/n)?" "git init --bare $directory"
}

function cloneRemote () {
      echo "Where?"
     . ~/Personal/fl.sh
     pwd
     echo "Remote repository url:"
     read url
     git clone $url
}

function defineAuthor () {
	echo "Enter author name:"
	read aname
	git config --global user.name $aname
	echo "Ente email:"
	read email
	git config --global user.email $email
}

function textEditor () {
	echo "Enter text editor name (the command how you call it in the shell):"
	read editor
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
	echo "Enter merge tool name (the command how you call it in the shell):"
	read editor
    git config --global merge.tool $editor
}

while ${continuemenu:=true}; do
clear
menuInit "Repositories"
submenuHead "Setting up repositories"
menuItem a "Transform the current directory into a git repository" atLocalGit
menuItem b "Setting up a git repository in a directory" atLocalGitWithDir
menuItem c "Setting up a shared git repository in a directory" atLocalGitBare
menuItem d "Clone a remote repository" cloneRemote
echo
submenuHead "Configure repositories:"
menuItem e "Define the author name and email to be used for all commits" defineAuthor
menuItem f "Administering aliases" adminAliases
menuItem g "Define the text editor used by commands" textEditor
menuItem h "Define merge tool" defineMergeTool
menuItem i "Open global config" openGlobalConfig
menuItem j "Open system config" openSystemConfig
menuItem k "Open local config" openLocalConfig

choice
done
noterminate