#!/bin/bash

mvnCleanEclipse(){
    mvn clean:clean
    mvn eclipse:clean
    mvn eclipse:eclipse
}

startSpringBoot() {
   echo "Which profile? (optional)"
   read defprofiles
   if [ "$defprofiles" = "" ]; then
      mvn spring-boot:run
   else
   	  mvn spring-boot:run -Dspring-boot.run.profiles=$defprofiles
   fi
}

showGlobalSettings(){
   OUTPUT="$(mvn -X | grep -F '[DEBUG] Reading global settings from')"
   echo ${OUTPUT:37}
   read -p "Open global settings? " -n 1 -r
   echo    # (optional) move to a new line
   if [[ $REPLY =~ ^[Yy]$ ]]
       then
       vim ${OUTPUT:37}
   fi      
}

showLocalSettings() {
   OUTPUT="$(mvn -X | grep -F '[DEBUG] Reading user settings from')"
   echo ${OUTPUT:35}
   read -p "Open user settings? " -n 1 -r
   echo    # (optional) move to a new line
   if [[ $REPLY =~ ^[Yy]$ ]]
       then
       vim ${OUTPUT:35}
   fi      
}

downLoadSources() {
   mvn dependency:sources
   mvn eclipse:eclipse -DdownloadSources=true
}

toRepo() {
   repo=$(mvn help:evaluate -Dexpression=settings.localRepository | grep -v '\[INFO\]')
   cd "$repo"
   echo "Now in: $(pwd)"
   exit
}

newProject() {
   echo "Command expects the user to be in the new cloned repo folder. <taste drücken>"
   read
   echo "Project name?"
   read projektname
   mvn archetype:generate -DartifactId=$projektname \
                          -DinteractiveMode=true
   mv $projektname/* .
   rm -rf $projektname/
   mvn compile
   mvn eclipse:eclipse
   git status > .gitignore
   vim .gitignore
   break
}
