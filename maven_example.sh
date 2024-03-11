#!/bin/bash

########################
#  Maven example menu  #
########################

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$script_dir/shellmenu.sh"

showGlobalSettingFile() {
  OUTPUT="$(mvn -X | grep -F '[DEBUG] Reading global settings from')"
  echo ${OUTPUT:37}
  read -p "Open global settings? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
      then
      vim ${OUTPUT:37}
  fi
}

while ${continuemenu:=true}; do
clear
menuInit "Super KUBECTL Home"
  submenuHead "Life cycle commands:"
     menuItem c "Clean all" "mvn clean:clean"
     menuItem x "Compile" "mvn clean compile" 
     menuItem t "Test" "mvn clean test" 
     menuItem i "Install" "mvn clean install"  
  echo
  submenuHead "Also usefull:"
    menuItem d "Analyze dependencies" "mvn dependency:analyze"
    menuItem u "Clean compile force updates" "mvn clean compile -U -DskipTests" 
    menuItem e "Show effective settings" "mvn help:effective-settings"
    menuItem r "Show local repo location" "mvn help:evaluate -Dexpression=settings.localRepository | grep -v '\[INFO\]'" 
    menuItem l "Show global settings file location" showGlobalSettingFile
    echo && importantLog $(pwd)
  choice
done
echo "bye, bye, homie!"
