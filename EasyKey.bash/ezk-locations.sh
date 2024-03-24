#!/bin/bash

unset locations

script_dir="$1"
source "${script_dir}/shellmenu.sh"

configfilename=.ezk-bash-config

function toDirAndTerminate () {
  vars="$*" # all splitted words back to one var
  blueLog "toDir $vars"
  eval "cd ${vars// /\\ }" # escape spaces
  nowaitonexit
  terminate
}

# Reads the config into global array "workspaces"
# The config needs to have that section [workspaces]
initConfig "${script_dir}/EasyKey.bash/${configfilename}"

clear
thekeys=($(echo {a..p}) $(echo {r..z}) $(echo {1..9}) $(echo {A..Z}))
declare -x keycounter=1

menuInit "Quick Locations"
submenuHead "Registered locations:"
OLD_IFS=$IFS
for (( i = 1; i < (( ${#locations[@]} + 1 )); i++ )); do
    IFS="=" read -r locname locdestination <<< "${locations[i]}"
    menuItem "${thekeys[keycounter]}" "$locdestination" "toDirAndTerminate ${locdestination}"
    ((keycounter++))
done
echo "${menudatamap[@]}"
IFS=$OLD_IFS
submenuHead "Shortcuts"
menuItem X "Purge git dir cache" purgDirCache
echo "${menudatamap[@]}"
startMenu

source "${script_dir}/shellmenu.sh"
unset locations