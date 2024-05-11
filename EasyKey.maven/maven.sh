#!/bin/bash

#####################################
# EasyKey.maven utility main script #
#####################################

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$script_dir/../shellmenu.sh"
source "$script_dir/ezk-maven-functions.sh"

globalClmWidth=20

menuInit "Super MAVEN Home"
 submenuHead "Working with Maven POM "
  menuItemClm a "Clean all eclipse" "mvnCleanEclipse" b "Maven analyze dependencies" "mvn dependency:analyze"
  menuItemClm c "Clean install force updates" "mvn clean install -U -DskipTests" d "To maven repo" toRepo 
  menuItemClm e "Show effective settings" "mvn help:effective-settings" f "Local repo location" "mvn help:evaluate -Dexpression=settings.localRepository | grep -v '\[INFO\]'" 
  menuItemClm g "Show global settings" showGlobalSettings h "Show local settings" showLocalSettings  
  menuItemClm i "Re-resolve project dependencies" "mvn dependency:purge-local-repository" j "List repositories" "mvn dependency:list-repositories"  
  menuItemClm k "Download sources" downLoadSources l "Build with deps" "mvn clean compile assembly:single"  
  menuItemClm m "New project from archetype" newProject p "Effective pom" "mvn help:effective-pom"
  menuItemClm t "Dependency tree" "mvn dependency:tree" u "Display dependency updates" "mvn versions:display-dependency-updates -DexcludeReactor=true"
  menuItemClm v "Enforce dependencies check" "mvn enforcer:enforce -B -Drules=DependencyConvergence" w "OPEN API Refresh" "mvn generate-sources && mvn clean compile"
 submenuHead "Lifecycle "
  menuItemClm C "Clean compile" "mvn clean compile" T "Clean test" "mvn clean test"
  menuItemClm I "Clean install" "mvn clean install -DskipTests" P "Clean package" "mvn clean package -DskipTests"
  menuItem D "Clean deploy" "mvn clean deploy -DskipTests"
 submenuHead "Spring-Boot "
  menuItemClm o "Start Spring Boot App" startSpringBoot s "View application properties" showProperties
  menuItemClm x "Usefull notes" useFull y "JMX Metrics" runJmx
  menuItemClm z "Actuator mappings" printActuatorMappings 1 "Application mappings" printMappings
startMenu "pwd"
