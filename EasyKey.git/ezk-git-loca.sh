#!/bin/bash

oldmenudata=("${menudatamap[@]}")

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$script_dir/../shellmenu.sh"
source "$script_dir/ezk-git-functions.sh"

configfilename=.ezk-git-loca-conf

function toDir () {
	vars="$*" # all splitted words back to one var
	eval cd "${vars// /\\ }" # escape spaces
	nowaitonexit
    terminate
}

function toDirAndTerminate () {
  vars="$*" # all splitted words back to one var
  eval "cd ${vars// /\\ }" # escape spaces
  nowaitonexit
  terminate
}

function purgDirCache () {
	unset gitlocations
}

# Reads the config into global array "workspaces"
# The config needs to have that section [workspaces]
initConfig "${script_dir}/${configfilename}"

thekeys=($(echo {a..p}) $(echo {r..z}) $(echo {1..9}) $(echo {A..Z}))
declare -x keycounter=0
menuInit "GIT locations"
uncached=false
priorlocation=$(pwd) # remember actual location
if [ -z ${gitlocations+x} ]; then
   uncached=true
   index=0
   for j in "${workspaces[@]}"
   do
   	  locationdir=$(echo "$j" | cut -f2 -d'=')
   	  eval cd $locationdir
   	  lines=$(eval find $locationdir -name ".git")
      while read line; do
       	completelocation=${line::${#line}-5}
       	gitlocations[$index]="${thekeys[$keycounter]} $completelocation toDir $completelocation"
        ((keycounter++))
        ((index++))
      done <<< "$(echo -e "$lines")"
   done
fi
eval cd "${priorlocation// /\\ }" # return to previous location
# print out git location cache
submenuHead "GIT repos inside workspaces:"
echo
for (( i = 0; i < ${#gitlocations[@]}; i++ )); do
    arrIN=(${gitlocations[$i]})
	IFSOLD=$IFS
	IFS=' ' 
	read -r -a filenamearray <<< "${arrIN[1]}"
	IFS=$IFSOLD
	menuItem "${arrIN[0]}" "${arrIN[1]}" "${arrIN[2]} ${arrIN[3]}" 
done
if $uncached; then coloredLog "NEW" "1;42"; else coloredLog "CACHED" "1;42"; fi
submenuHead "Shortcuts"
menuItem X "Purge git dir cache" purgDirCache
startMenu

source "$script_dir/../shellmenu.sh"
menudatamap=("${oldmenudata[@]}")

noterminate
