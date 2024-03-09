#!/bin/bash
echo "Fullqualified Target Workspace Directory:"
read target
echo "User Name:"
read username
echo "Neues Passwort:"
read neuespasswort

cd $target
array=($(ls -d */))
for i in "${array[@]}"
do
	echo $i
	cd $i
	git remote set-url origin https://$username:$neuespasswort@git-ext.provinzial.com/sdirekt/${i%?}.git/
	cd ..
done