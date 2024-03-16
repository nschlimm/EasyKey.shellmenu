#!/bin/bash

enableLogging() {
   echo "Root logger (global default logging level):"
   echo "logging.level.root=warn"
   echo "Stuff in my app:"
   echo "logging.level.com.myapp=DEBUG"
   echo "All Spring:"
   echo "logging.level.org.springframework=DEBUG"
   echo "Spring Web:"
   echo "logging.level.org.springframework.web=debug"
   echo "Display endpoints at startup:"
   echo "logging.level.web=TRACE"
   echo "logging.level.web=DEBUG"
   echo "Rest:"
   echo "logging.group.rest=org.springframework.web,org.springframework.http"
   echo "logging.level.rest=DEBUG"
   echo "Tomcat:"
   echo "logging.group.tomcat=org.apache.catalina, org.apache.coyote, org.apache.tomcat"
   echo "logging.level.tomcat=DEBUG"
   echo "Hibernate:"
   echo "logging.level.org.hibernate=error"
   echo "Autoconfig:"
   echo "logging.level.org.springframework.boot.autoconfigure=DEBUG"
   echo "SQL"
   echo "logging.level.sql=DEBUG"
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
   echo "JPA SQL:"
   echo "spring.jpa.show-sql=true"
   echo "With Actuator:"
   echo "management.endpoints.web.exposure.include=mappings"
   echo "http://localhost:8080/actuator/mappings"
}

showProperties() {
   selectItem "find ./src -type f -name 'application*.*'" "awk '{print \$1}'"
   if [[ $fname == "" ]]; then return 0; fi
   vim "$fname"
}

mvnCleanEclipse(){
    mvn clean:clean
    mvn eclipse:clean
    mvn eclipse:eclipse
}

startSpringBoot() {
   echo "Which profile? (optional)"
   read defprofiles
   defprofiles=-Dspring-boot.run.profiles=${defprofiles}
   my_array=("logging.level.web=DEBUG" \
             "logging.level.sql=DEBUG" \
             "logging.level.web=TRACE" \
             "logging.level.sql=TRACE" \
             "spring.jpa.show-sql=true")
   concatenated=$(printf "%s\n" "${my_array[@]}")
   selectItem 'printf "%s\n" "${my_array[@]}"' "awk '{print \$1}'"
   if [[ $fname == "" ]]; then return 0; fi
   mvn spring-boot:run -Dspring-boot.run.arguments=--"$fname" ${defprofiles}
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
