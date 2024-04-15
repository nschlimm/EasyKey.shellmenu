#!/bin/bash

useFull() {
   echo "Usefull stuff to remember:"
   echo
   echo "Printout mappings at application start:"
   echo -e " \n
    @EventListener \n
    public void handleContextRefresh(ContextRefreshedEvent event) { \n
        ApplicationContext applicationContext = event.getApplicationContext(); \n
        RequestMappingHandlerMapping requestMappingHandlerMapping = applicationContext \n
            .getBean("requestMappingHandlerMapping", RequestMappingHandlerMapping.class); \n
        Map<RequestMappingInfo, HandlerMethod> map = requestMappingHandlerMapping \n
            .getHandlerMethods(); \n
        map.forEach((key, value) -> log.info("{} {}", key, value)); \n
    }"
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
   echo "Which profile?"
   read defprofiles
   my_array=("logging.level.root=DEBUG" \
             "logging.level.org.springframework.web=TRACE"
             "logging.level.web=DEBUG" \
             "logging.level.sql=DEBUG" \
             "logging.level.web=TRACE" \
             "logging.level.sql=TRACE" \
             "spring.jpa.show-sql=true" \
             "logging.level.org.springframework=DEBUG" \
             "logging.level.org.springframework.jdbc.core=TRACE" \
             "management.endpoints.web.exposure.include=mappings" \
             "logging.group.tomcat=org.apache.catalina,org.apache.coyote,org.apache.tomcat,--logging.level.tomcat=DEBUG" \
             "logging.level.org.hibernate=DEBUG" \
             "logging.level.org.springframework.boot.autoconfigure=DEBUG" \
             "logging.level.org.springframework.test.context.jdbc=DEBUG" \
             "logging.level.org.springframework.jdbc.datasource.init=DEBUG" \
             "spring.jpa.hibernate.ddl-auto=validate" \
             "spring.jpa.properties.hibernate.generate_statistics=true,--logging.level.org.hibernate.stat=DEBUG,--spring.jpa.properties.hibernate.session.events.log.LOG_QUERIES_SLOWER_THAN_MS=1,--logging.level.org.hibernate.SQL=DEBUG,--logging.level.org.hibernate.cache=DEBUG")
   concatenated=$(printf "%s\n" "${my_array[@]}")
   selectItem 'printf "%s\n" "${my_array[@]}"' "awk '{print \$1}'"
   if [[ $fname == "" ]]; then return 0; fi
   executeCommand "SPRING_PROFILES_ACTIVE="$defprofiles" mvn spring-boot:run -Dspring-boot.run.arguments=--"$fname""
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
