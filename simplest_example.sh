#!/bin/bash

########################
#  Simplest example    #
########################

source "./shellmenu.sh"

clear
menuItem c "Clean all" "mvn clean:clean"
menuItem x "Compile" "mvn clean compile" 
menuItem t "Test" "mvn clean test" 
menuItem i "Install" "mvn clean install"  
startMenu "pwd"
echo "bye, bye, homie!"
