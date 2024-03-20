#!/bin/bash

####################################
# EasyKey.bash utility main script #
####################################

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$script_dir/../shellmenu.sh"

findText(){
   echo "Text pattern:"
   read textPattern
   echo "File pattern:"
   read filePattern
   find . -name "$filePattern" -exec grep -H "$textPattern" {} + | awk -F ":" '{printf "%-40s %s\n", $1, $2}'
}

menuInit "EasyKey.bash"
 submenuHead "Usefull:"
  menuItem f "Find text inside files" findText
startMenu "$(pwd)"
