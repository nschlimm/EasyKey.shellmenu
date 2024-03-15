#!/bin/bash

#####################################
# EasyKey.maven utility main script #
#####################################

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$script_dir/../shellmenu.sh"
source "$script_dir/ezk-maven-functions.sh"

enableLogging() {
   echo "logging:"
   echo "  level:"
   echo "    org: "
   echo "      springframework: "
   echo "        test: "
   echo "          context:"
   echo "            jdbc: DEBUG"
   echo "        jdbc:"
   echo "          datasource:"
   echo "            init: DEBUG"

echo "logging.level.org.springframework=DEBUG"
echo "logging.level.com.myapp=DEBUG"

echo "org.springframework.boot.autoconfigure=DEBUG"
}

menuInit "Super MAVEN Home"
 submenuHead "Maven:"
  menuItemClm a "Clean all eclipse" "mvnCleanEclipse" b "Maven analyze dependencies" "mvn dependency:analyze"
  menuItemClm c "Clean install force updates" "mvn clean install -U -DskipTests" d "To maven repo" toRepo 
  menuItemClm e "Show effective settings" "mvn help:effective-settings" f "Local repo location" "mvn help:evaluate -Dexpression=settings.localRepository | grep -v '\[INFO\]'" 
  menuItemClm g "Show global settings" showGlobalSettings h "Show local settings" showLocalSettings  
  menuItemClm i "Re-resolve project dependencies" "mvn dependency:purge-local-repository" j "List repositories" "mvn dependency:list-repositories"  
  menuItemClm k "Download sources" downLoadSources l "Build with deps" "mvn clean compile assembly:single"  
  menuItemClm m "New project from archetype" newProject "p" "Effective pom" "mvn help:effective-pom"
 submenuHead "Spring-Boot:"
  menuItemClm o "Start Spring Boot App" startSpringBoot p "Enable logging" enableLogging
startMenu
