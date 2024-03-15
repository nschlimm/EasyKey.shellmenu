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

