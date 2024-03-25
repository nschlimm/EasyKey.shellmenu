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
   find . -name "$filePattern" -exec grep -Hn "$textPattern" {} + | awk -F ":" '{printf "%-40s %s\n", $1, $2}'
}

findFiles(){
   echo "File pattern:"
   read filePattern
   find . -name "$filePattern"
}

findTextAll() {
   echo "Text pattern:"
   read textPattern
   find . -type f -exec grep -Hn "$textPattern" {} + | awk -F ":" '{printf "%-40s %-4s %s\n", $1, $2, $3}'
}

whichSoftware() {
   echo "Which software to search?"
   read software
   [ "${software}" = "" ] && waitonexit && return 
   which -a $software
}

menuInit "EasyKey.bash"
 submenuHead "Usefull "
  menuItem f "Find files by pattern" findFiles 
  menuItem t "Find text inside specific files" findText
  menuItem o "Find test inside all files" findTextAll
  menuItem l "Largest directories" "du -hsx .[!.]* * | sort -rh | head -10" 
  menuItem m "Largest files" "find . -type f -exec du -h {} + | sort -rh | head -n 10"
  menuItem n "Size of current directory" "du -sh ."
  menuItem w "Where is my software installed?" whichSoftware
startMenu "pwd"
