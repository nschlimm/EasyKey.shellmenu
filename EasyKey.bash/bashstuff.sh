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

findFiles(){
   echo "File pattern:"
   read filePattern
   find . -name "$filePattern"
}

menuInit "EasyKey.bash"
 submenuHead "Usefull:"
  menuItemClm f "Find files by pattern" findFiles t "Find text inside files" findText
  menuItemClm l "Largest directories" "du -hsx .[!.]* * | sort -rh | head -10" m "Largest files" "find . -type f -exec du -h {} + | sort -rh | head -n 10"
  menuItem n "Size of current directory" "du -sh ."
startMenu "$(pwd)"
