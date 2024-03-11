#!/bin/bash

#################################
# EasyKey.shellmenu main script #
#################################

# Globals
waitonexit=true;
continuemenu=true
globalClmWidth=45

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
  menudatamap=()
  export GREP_COLOR='1;37;44'
  echo "$1" | grep --color ".*"
  export GREP_COLOR='01;31'
  echo
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
  export GREP_COLOR='1;36'
  echo "$1" | grep --color ".*"
  export GREP_COLOR='01;31'
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
   menudatamap+=("$1#$2#$3#$actualsubmenuname#$actualmenu")
   echo "$1. $2"
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
   menudatamap+=("$1#$2#$3#$actualsubmenuname#$actualmenu")
   menudatamap+=("$4#$5#$6#$actualsubmenuname#$actualmenu")
   echo -e "${1}.,${2},${4}.,${5}" \
      | awk -F , -v OFS=, '{printf "%-3s",$1; 
                            printf "%-'"${clmLocalWidth}"'s",$2; 
                            printf "%-3s",$3; 
                            printf "%-'"${clmLocalWidth}"'s",$4; 
                            printf("\n"); }'
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
#   $2: color code, e.g. "01;31"
# Outputs:
#   Writes colored log to standard out
#######################################
coloredLog () {
  export GREP_COLOR="$2"
  echo "$1" | grep --color ".*"
  export GREP_COLOR='01;31'
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
  coloredLog "${log}" '1;37;44'
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
  coloredLog "${log}" '1;97;42'
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
  coloredLog "${log}" '1;37;44'
}

#######################################
# Writes 'important' log text to stdout
# Arguments:
#   $1: log text
# Outputs:
#   Writes log to standard out
#######################################
importantLog() {
   echo -e -n "\033[1;36m"
   echo $1
   echo -e -n '\033[0m'
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
    echo "Select line or hit enter for preselection [${xpreselection}]:"
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
   #!/bin/bash
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
   coloredLog "${csvfile}" '1;37;44'
   headers=$(head -1 "$csvfile" | sed 's/ /_/g' | awk -F, 'BEGIN {i=1} {while (i<=NF) {str=str substr($i,1,12)","; i++;}} END {print str}')
   selectItem '(echo "${headers}" && sed -n '"${linefrom}"','"${lineto}"'p "${csvfile}") | perl -pe "s/((?<=,)|(?<=^)),/ ,/g;" | column -t -s, | less -S' '.*' 192 1 "$preselection" "$xdarkprocessing"
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
   coloredLog "${csvfile}" '1;37;44'
   ! [ "${heading}" = "" ] && coloredLog "${heading}"
   if [ "${width}" = "" ]; then
     (echo "${headers}" && sed -n "${linefromXX},${linetoXX}p" "${csvfile}") | perl -pe 's/((?<=,)|(?<=^)),/ ,/g;' | column -t -s, | less -S | alternateRows 1
   else
     (echo "${headers}" && sed -n "${linefromXX},${linetoXX}p" "${csvfile}") | perl -pe 's/((?<=,)|(?<=^)),/ ,/g;' | column -t -s, | less -S | awk -v m=${width} '{printf("[%-'${width}'s]\n", $0)}' | alternateRows 1
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
# Globals:
#   menudatamap - the menu data
# Outputs:
#   The executed user defined function or command
#################################################
callKeyFunktion () { 
   for i in "${menudatamap[@]}"
     do
       keys2=$(echo "$i" | cut -d'#' -f1)
         if [ "$1" = "$keys2" ]
           then
              method=$(echo "$i" | cut -f3 -d#)
              clear && coloredLog "$method" '1;37;44'
              eval "$method"
              return 1
         fi
   done
   return 5
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
  echo
  echo "Press 'q' to quit"
  echo
  read -p "Make your choice: " -n 1 -r
  echo

  if [[ $REPLY == "q" ]]; then
       terminate
  else
    callKeyFunktion "$REPLY"
    if [[ $? -gt 1 ]]; then
      coloredLog "Huh ($request)?" "1;31"
    fi
    if $waitstatus; then
      read -p $'\n<Press any key to return>' -n 1 -r
    else
      waitonexit # back to default after method execution
    fi
  fi

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

