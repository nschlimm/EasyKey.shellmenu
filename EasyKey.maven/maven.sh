#!/bin/bash

#####################################
# EasyKey.maven utility main script #
#####################################

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$script_dir/../shellmenu.sh"
source "$script_dir/ezk-mavem-functions.sh"

menuInit "Super MAVEN Home"
 submenuHead "Maven:"
  menuItemClm a "Clean all eclipse" "mvnCleanEclipse" b "Maven analyze dependencies" "mvn dependency:analyze"
  menuItemClm c "Clean install force updates" "mvn clean install -U -DskipTests" d "To maven repo" tbd 
  menuItemClm e "Show effective settings" "mvn help:effective-settings" f "Local repo location" "mvn help:evaluate -Dexpression=settings.localRepository | grep -v '\[INFO\]'" 
  menuItemClm g "Show global settings" showGlobalSettings h "Show local settings" showLocalSettings  
  menuItemClm i "Re-resolve project dependencies" "mvn dependency:purge-local-repository" j "List repositories" "mvn dependency:list-repositories"  
  menuItemClm k "Download sources" downLoadSources l "Build with deps" "mvn clean compile assembly:single"  
 submenuHead "Spring-Boot:"
  menuItem j "Start Spring Boot App" startSpringBoot
startMenu
