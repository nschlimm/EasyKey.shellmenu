#!/bin/bash

#################################
# EasyKey.shellmenu main script #
#################################

# Colors
clrBlack=0
clrRed=1
clrGreen=2
clrYewllow=3
clrBlue=4
clrPurple=5
clrCyan=6
clrWhite=7

# Globals
waitstatus=true
continuemenu=true
globalClmWidth=45
immediateMode=false
actualmenu="EasyKey.shellmenu"
actualsubmenuname="Your commands:"
menuHeadingFGClr="$clrWhite"
menuHeadingBGClr="$clrBlue"
submenuFGClr="$clrWhite"
submenuBGClr="$clrPurple"
delimiter=⊕
formattedTop=""
formattedBottom=""
formattedMiddle=""
generatedmenu=""

############################
############################
# API to create shell menu #
############################
############################

#################################################
# Writes the menu title and prepares menu array.
# Arguments:
#   $1: menu title, e.g. "Git Utility"
# Outputs:
#   Creates menudatamap global variable
#################################################
menuInit () {
  actualmenu="$1"
  actualsubmenuname="Your commands:"
  menudatamap=()
  ${immediateMode} && printMenuHeading "$1"
}

#################################################
# Creates a submenu title and the data structure
# Arguments:
#   $1: sub menu title, e.g. "Git Utility"
# Outputs:
#   Creates actualsubmenuname global variable
#################################################
submenuHead () { 
  actualsubmenuname="$1"
  ${immediateMode} && printSubmenuHeading "$1"
}

#################################################
# Creates a single column menu item
# Arguments:
#   $1: key, e.g. "b"
#   $2: menu item name, e.g. "Copy files"
#   $3: name of shell function to call, or the 
#       shell command itself.
# Globals:
#   menudatamap - the menu data
#   actualsubmenuname - the actual submenu 
#   actualmenu - the actual main menu
# Outputs:
#   Adds menu item data to menudatamap array.
#   Prints the menu item to standard out.
#################################################
menuItem () {
   menudatamap+=("$1$delimiter$2$delimiter$3$delimiter$actualsubmenuname$delimiter$actualmenu${delimiter}1")
   ${immediateMode} && printMenuItem "$1" "$2"
}

#################################################
# Creates a multi column menu item
# Arguments:
#   $1: key, e.g. "b"
#   $2: menu item name, e.g. "Copy files"
#   $3: name of shell function to call, or the 
#       shell command itself.
#   $4: key, e.g. "c"
#   $5: menu item name, e.g. "Delete files"
#   $6: name of shell function to call, or the 
#       shell command itself.
# Globals:
#   menudatamap - the menu data
#   actualsubmenuname - the actual submenu 
#   actualmenu - the actual main menu
#   globalClmWidth - the column width
# Outputs:
#   Adds menu item data to menudatamap array.
#   Prints the menu item to standard out.
#################################################
menuItemClm () {
   clmLocalWidth=${globalClmWidth:=45}
   menudatamap+=("$1$delimiter$2$delimiter$3$delimiter$actualsubmenuname$delimiter$actualmenu${delimiter}1")
   menudatamap+=("$4$delimiter$5$delimiter$6$delimiter$actualsubmenuname$delimiter$actualmenu${delimiter}2")
   ${immediateMode} && printMenuItemClm "$1" "$2" "$4" "$5"
}

#################################################
# The entry method to display the menu in non
# immediate mode (the default mode)
# Arguments:
#   $1: a custom output at the bottom of menu
#       (e.g. current directory)
# Outputs:
#   the menu written to stdout
#################################################
startMenu() {
   while ${continuemenu:=true}; do
      clear
      if [ "$generatedmenu" = "" ]; then
        generateMenu
      fi
      printf "$generatedmenu"
      choice "$1"
   done
}

#####################################
#####################################
# API to help write shell functions #
# called by shellmenu               #
#####################################
#####################################

#######################################
# Colored log to standard out.
# Arguments:
#   $1: log text
#   $2: optional: foreground color (0-7)
#   $3: optional: background color (0-7)
#   $4: optional: width of heading line
# Outputs:
#   Writes colored log to standard out
#######################################
coloredLog () {
    set_foreground=$(tput setaf "${2:-$clrWhite}")
    set_background=$(tput setab "${3:-$clrBlack}")
    echo -n "$set_background$set_foreground"
    printf "%s" "$1"
    tput sgr0
    if [ $# -eq 4 ]; then
      length=${#1}
      width=73
      pad=$(( width - length ))
      set_foreground=$(tput setaf "$3")
      set_background=$(tput setab "$clrBlack")
      echo -n "$set_background$set_foreground"
      printf "%s" $(pad_string_with_stars "─" $pad)
      tput sgr0
    fi
    printf "\n\r"
}

pad_string_with_stars() {
    local string="$1"
    local count="$2"
    local padded_string=""

    for ((i = 0; i < count; i++)); do
        padded_string+="─"
    done

    padded_string+="$string"

    echo -n "$padded_string"
}

#######################################
# Writes log text to standard out.
# Background blue. Font color white.
# Arguments:
#   $1: log text
# Outputs:
#   Writes colored log to standard out
#######################################
blueLog() {
  log="$1"
  coloredLog "${log}" "$clrWhite" "$clrBlue"
}

#######################################
# Writes log text to standard out.
# Background green. Font color white.
# Arguments:
#   $1: log text
# Outputs:
#   Writes colored log to standard out
#######################################
greenLog() {
  log="$1"
  coloredLog "${log}" "$clrWhite" "$clrGreen"
}

#######################################
# Writes log text to standard out.
# Background red. Font color white.
# Arguments:
#   $1: log text
# Outputs:
#   Writes colored log to standard out
#######################################
redLog() {
  log="$1"
  coloredLog "${log}" "$clrRed" "$clrBlack"
}

#######################################
# Writes 'important' log text to stdout
# Arguments:
#   $1: log text
# Outputs:
#   Writes log to standard out
#######################################
importantLog() {
  coloredLog "$1" "$clrCyan" "$clrBlack"
}

#################################################
# Executes a so called list command. That is a 
# command like 'ls -l' that returns a list.
# This function executes the list command and
# gives every item in the list an ID. The header
# will have the ID=1, the first row most often
# ID=2. Users can select the list item and
# execute user defined functions based on the
# data of that list item.
# Arguments:
#   $1: the list command
#   $2: the awk command or regex to grep a column
#       value of the selected list item
#   $3: the width of the displayed list, optional
#   $4: ID of the header, usually "1", optional
#   $5: Preselcted item in the list, optional
# Outputs:
#      linenumber - selected line number
#      selected - the complete line selected)
#      fname - selected line after regular expression 
#              or awk cmd applied -> what you want to 
#              have as return value from selection.
#              often the main output of this function!
#################################################
selectItem () { 
  listkommando="$1"
  regexp="$2"
  width="$3"
  header="$4"
  xpreselection="$5"

  blueLog "${listkommando}"

  if [[ $width = "" ]]; then
    eval "$listkommando" | nl -n 'ln' -s " "
  else 
    eval "$listkommando" \
       | nl -n 'ln' -s " " \
       | awk -v m="${width}" '{printf("[%-'"${width}"'s]\n", $0)}' \
       | alternateRows "$header"
  fi
  linenumber=""
  selected=""
  dfltln=${xpreselection}
  if [ "$xdarkprocessing" = "" ]; then
    echo "Select line or hit ENTER to select nothing:"
    read -r linenumber
  fi
  linenumber=${linenumber:-$dfltln}
  linenumber=$(echo "${linenumber}" | cut -d '.' -f1)
  re='^[0-9]+$'
  if ! [[ $linenumber =~ $re ]]; then
     selected=""
     message=${linenumber}
     fname=""
   else
     selected=$(eval "$listkommando" | sed -n "${linenumber}"p)
     echo "$selected"
     if echo "$regexp" | grep -q "awk"; then
       blueLog "awk detected $regexp"
       fname=$(echo "$selected" | eval "$regexp")
     else
       fname=$(echo "$selected" | grep -oh "${regexp:-.*}")
     fi
  fi
  echo "... selected ${fname:-nothing}"
}

#################################################
# Enables alternate coloring of lines in long 
# lists for improved readability.
# Arguments:
#   Reads stdin -> the line of the list displayed
#   $1: the header id of the table
# Outputs:
#   Writes a colored or non-colored line to stdout
#################################################
alternateRows() {
   header="$1"
   i=1
   while read -r line
    do
      if [[ $i == 1 ]] && [[ $header != "" ]]; then
        echo -e "\033[48;5;93m$line\033[0m"
      else 
        echo -e "\033[48;5;238m$line\033[0m"
      fi
      read -r line
      echo -e "\033[48;5;232m$line\033[0m"
      i=$((i+1))
    done
    echo -en "\033[0m"
}

#################################################
# Selelect rows or columns from CSV file. 
# Uses selectItem(). Supports paging.
# Arguments:
#   $1: source csv file full name
#   $2: paging line from
#   $3: paging line to
#   $4: pre selected line
# Outputs:
#   see selectItem() outputs
#################################################
selectFromCsv() { 
   csvfile=$1 #source csv file full name
   linefrom=$2 #paging line from
   lineto=$3 #paging line to
   preselection=$4
   xdarkprocessing="$5"
   linefrom=${linefrom:=2}
   lineto=${lineto:=80}
   importantLog "${csvfile}"
   headers=$(head -1 "$csvfile" | sed 's/ /_/g' \
       | awk -F, 'BEGIN {i=1} {while (i<=NF) {str=str substr($i,1,12)","; i++;}} END {print str}')
   selectItem '(echo "${headers}" && sed -n '"${linefrom}"','"${lineto}"'p "${csvfile}") \
       | perl -pe "s/((?<=,)|(?<=^)),/ ,/g;" \
       | column -t -s, | less -S' '.*' 192 1 "$preselection" "$xdarkprocessing"
}

#################################################
# Display CSV file in colorized format.
# Supports paging.
# Arguments:
#   $1: source csv file full name
#   $2: paging line from
#   $3: paging line to
#   $4: width of the table
#   $5: count of heading lines
# Outputs:
#   Writes the CSV table nicely to stdout
#################################################
coloredCsvTable() { #show csv file with header line in nice format
   csvfile="$1" #source csv file full name
   linefromXX="$2" #paging line from
   linetoXX="$3" #paging line to
   width="$4" # optional if coloring is desired
   heading="$5" # count of heading lines
   if [ "${linefromXX}" = "1" ]; then linefromXX="2"; fi
   headers=$(head -1 $csvfile | sed 's/ /_/g' | awk -F, 'BEGIN {i=1} {while (i<=NF) {str=str substr($i,1,12)","; i++;}} END {print str}')
   importantLog "${csvfile}"
   ! [ "${heading}" = "" ] && coloredLog "${heading}"
   if [ "${width}" = "" ]; then
     (echo "${headers}" && sed -n "${linefromXX},${linetoXX}p" "${csvfile}") \
        | perl -pe 's/((?<=,)|(?<=^)),/ ,/g;' \
        | column -t -s, \
        | less -S \
        | alternateRows 1
   else
     (echo "${headers}" && sed -n "${linefromXX},${linetoXX}p" "${csvfile}") \
        | perl -pe 's/((?<=,)|(?<=^)),/ ,/g;' \
        | column -t -s, \
        | less -S \
        | awk -v m=${width} '{printf("[%-'${width}'s]\n", $0)}' \
        | alternateRows 1
   fi
}

#################################################
# Used to indicate ez.key that it may not wait
# after command execution and immediately return
# to main menu.
# Globals:
#   waitstatus - actual wait state
# Outputs:
#   Changes global wait state
#################################################
nowaitonexit () {
  waitstatus=false
}

#################################################
# Used to indicate ez.key that it may wait for
# user to press key after command execution.
# After key press: to main menu.
# Globals:
#   waitstatus - actual wait state
# Outputs:
#   Changes global wait state
#################################################
waitonexit () {
  waitstatus=true
}

######################################
######################################
# INTERNAL API for EasyKey.shellmenu #
######################################
######################################

#################################################
# Calls the function or shell command associated
# to the key pressed by the user.
# Arguments:
#   $1: pressed key
# Globals:
#   menudatamap - the menu data
# Outputs:
#   The executed user defined function or command
#################################################
callKeyFunktion () { 
   OLD_IFS=$IFS
   for i in "${menudatamap[@]}"
     do
       IFS="$delimiter" read -r key description action submenu menu column <<< "$i"
         if [ "$1" = "$key" ]
           then
              clear && importantLog "$action"
              eval "$action"
              return 1
         fi
   done
   return 5
   IFS=$OLD_IFS
}

#################################################
# Generates the menu from the menudatamap.
# Globals:
#   menudatamap - the menu data
#   generatedmenu - the generated menu (string)
# Outputs:
#   the menu written to generatedmenu variable
#################################################
generateMenu () { 
  OLD_IFS=$IFS
  local previoussubmenu previouscolumn submenucount;
  submenucount=0
  skipnext=false
  for ((index=0; index<${#menudatamap[@]}; index++)); do
    if [ "$skipnext" = "true" ]; then 
      skipnext=false
      continue
    fi
    IFS="$delimiter" read -r key description action submenu menu column <<< "${menudatamap[index]}"
    IFS="$delimiter" read -r nextkey nextdescription nextaction nextsubmenu nextmenu nextcolumn <<< "${menudatamap[((index+1))]}"
    if [ "$index" -eq "0" ]; then generatedmenu+=$(printMenuHeading "$menu"); generatedmenu+=$(printf "\n\r"); fi
    if [ "$submenu" != "$previoussubmenu" ]; then 
       if [ "$submenucount" -gt 0 ]; then generatedmenu+=$(printf "\n\r"); fi
       generatedmenu+=$(printSubmenuHeading "$submenu") 
       submenucount=$(( submenucount+1 ));
    fi
    if [ "$((nextcolumn))" -eq "$((column + 1))" ]; then
      generatedmenu+=$(printMenuItemClm "$key" "$description" "$nextkey" "$nextdescription")
      skipnext=true
    else
      generatedmenu+=$(printMenuItem "$key" "$description")
    fi
    previoussubmenu="$submenu"
  done
  IFS="$OLD_IFS"
}

#################################################
# Executes the given command.
# Arguments:
#   $1: the command to execute
# Outputs:
#   Executed command
#################################################
executeCommand () {
 importantLog "Executing: '$1'"
 eval "$1"
 importantLog "Finished execution of '$1'"
}

noterminate () { continuemenu=true; }
terminate () { continuemenu=false; }

#################################################
# Initiates user input 
# Outputs:
#      Creates the interactive user input and
#      and initiates execution of command selected
#################################################
choice () {
  if [ -n "$1" ]; then
     echo
     importantLog "$1"
  fi
  echo
  echo "Press 'q' to quit"
  echo
  echo -n "Your choice: " && wait_for_keypress
  echo

  if [[ $REPLY == "q" ]]; then
       terminate
  else
    callKeyFunktion "$REPLY"
    if [[ $? -gt 1 ]]; then
      importantLog "Huh ($REPLY)?"
    fi
    if $waitstatus; then
      echo -n "<Press any key to return>" && wait_for_keypress
    else
      waitonexit # back to default after method execution
    fi
  fi

}

#################################################
# Print a double column menu line. 
# Arguments:
#   $1: first column key
#   $2: first column description
#   $3: second column key
#   $4: second column description
# Outputs:
#   The menu line to stdout
#################################################
printMenuItemClm() {
  echo -e "${1}.,${2},${3}.,${4}" \
          | awk -F , -v OFS=, '{printf "%-3s",$1; 
                                printf "%-'"${clmLocalWidth}"'s",$2; 
                                printf "%-3s",$3; 
                                printf "%-'"${clmLocalWidth}"'s",$4; 
                                printf("\n\r"); }'
}

#################################################
# Print a single column menu line. 
# Arguments:
#   $1: column key
#   $2: column description
# Outputs:
#   The menu line to stdout
#################################################
printMenuItem() {
   printf "%s. %s\n\r" "$1" "$2"
}

#################################################
# Print the menu head. 
# Arguments:
#   $1: menu head description
# Outputs:
#   The menu head to stdout
#################################################
printMenuHeading(){
  draw_rounded_square "$1"
}

#################################################
# Print the sub menu head. 
# Arguments:
#   $1: sub menu head description
# Outputs:
#   The sub menu head to stdout
#################################################
printSubmenuHeading(){
  coloredLog "$1" "$submenuFGClr" "$submenuBGClr"
}

quit () {
   echo "bye bye, homie!"
   nowaitonexit
   return
}

exitGently () {
   echo "bye bye, homie!"
   nowaitonexit
   exit 1
}

#################################################
# Draw title graphic 
# Globals:
#   formattedTop - top line of graphic
#   formattedMiddle - middle line of graphic
#   formattedBottom - bottom line of graphic
#   tput colors
# Arguments:
#   $1: menu head description
# Outputs:
#   The menu head graphic to stdout
#################################################
draw_rounded_square() {

    # Menu title cache
    if [ "$formattedTop" != "" ]; then
      printf "$formattedTop\n\r"
      printf "$formattedMiddle\n\r"
      printf "$formattedBottom\n\r"
      return
    fi

    local text="$1"
    local width=${#text}

    local horizontal_line="─"
    local top_left_corner="┌"
    local top_right_corner="┐"
    local bottom_left_corner="└"
    local bottom_right_corner="┘"
    local vertical_line="│"
    
    local border=""
    border+="$top_left_corner"
    for (( i=0; i<width+2; i++ )); do
        border+="$horizontal_line"
    done
    border+="$top_right_corner"
    
    formattedTop=$(tput setaf $clrWhite)$(tput setab $clrBlue)$(tput bold)$border$(tput sgr0)
    formattedMiddle=$(tput setaf $clrWhite)$(tput setab $clrBlue)$(tput bold)"$vertical_line "$(tput setaf $clrWhite)$(tput setab $clrBlue)$(tput bold)$text$(tput sgr0)$(tput setaf $clrWhite)$(tput setab $clrBlue)$(tput bold)" $vertical_line"$(tput sgr0)

    printf "$formattedTop\n\r"
    printf "$formattedMiddle\n\r"
    
    border="$bottom_left_corner"
    for (( i=0; i<width+2; i++ )); do
        border+="$horizontal_line"
    done
    border+="$bottom_right_corner"

    formattedBottom=$(tput setaf $clrWhite)$(tput setab $clrBlue)$(tput bold)$border$(tput sgr0)
    printf "$formattedBottom\n\r"

}

######################################################
# Reading single key input that works on most
# shells. Usage example:
#     echo -n "Your choice: " && wait_for_keypress
# Outputs:
#   REPLY - contains user selection (the key pressed)
######################################################
wait_for_keypress() {
    stty raw
    REPLY=$(dd bs=1 count=1 2> /dev/null)
    stty -raw
}

######################################################
# A magic function that reads a file with sections
# into global arrays named by this section.
# Sections in the file start with [<section name>].
# After that section heading the config lines follow.
# A new section begins with [<new section name>].
# Arguments:
#   $1: the config filename to read
# Outputs:
#   Global arrays that have the name of the sections
#   in the config file.
######################################################
initConfig () {
   # read config to global arrays
   INPUT="$1"
   [ ! -f "$INPUT" ] && { echo "Config file not found: $INPUT"; wait_for_keypress; }
   i=0
   configlines=$(cat "$INPUT")
   while read -r configline; do
      if echo "$configline" | grep -q "\[.*\]"; then
        configsection=$(echo "$configline" | grep -o "\[.*\]")
        configsectioname=${configsection:1:${#configsection}-2}
        i=0
        continue
      fi
      if [ -n "$configline" ]; then
         eval "${configsectioname}+=('$configline')"
      fi
      ((i++))
   done <<< "$(echo -e "$configlines")"
}

draw_border() {
  multiline_string="$1"

  lines=()
  while IFS= read -r line; do
     lines+=("$line")
  done <<< "$multiline_string"

  # Find the longest line length
  max_length=0
  for line in "${lines[@]}"; do
      length=${#line}
      if (( length > max_length )); then
          max_length=$length
      fi
  done

  # Print the top line of the square
  echo "+"$(printf "%-${max_length}s" | tr ' ' '-')"+"

  # Print the multiline string with side borders
  for line in "${lines[@]}"; do
      printf "| %-${max_length}s |\n" "$line"
  done

  # Print the bottom line of the square
  echo "+"$(printf "%-${max_length}s" | tr ' ' '-')"+"
}