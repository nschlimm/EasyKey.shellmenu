#!/bin/bash

useFull() {
   echo "Usefull stuff to remember:"
   echo
   echo "Printout mappings at application start:"
   echo "
    @EventListener
    public void handleContextRefresh(ContextRefreshedEvent event) {
        ApplicationContext applicationContext = event.getApplicationContext();
        RequestMappingHandlerMapping requestMappingHandlerMapping = applicationContext
            .getBean("requestMappingHandlerMapping", RequestMappingHandlerMapping.class);
        Map<RequestMappingInfo, HandlerMethod> map = requestMappingHandlerMapping
            .getHandlerMethods();
        map.forEach((key, value) -> log.info("{} {}", key, value));
    }"
    echo
    echo "Prometheus"
    echo
    echo "<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-registry-prometheus</artifactId>
</dependency>"
    echo
 }

showProperties() {
   selectItem "find . -type f \( -name 'application*.yml' -o -name 'application*.yaml' -o -name 'application*.properties' \)" "awk '{print \$1}'"
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
   echo
   echo "Choose Spring Boot Run Arguments:"
   echo
   fname="."
   completeargs=""
   while [[ $fname != "" ]]; do
      my_array=("logging.level.root=INFO" \
                "logging.level.root=DEBUG" \
                "logging.level.org.springframework.web=TRACE"
                "logging.level.web=DEBUG" \
                "logging.level.web=TRACE" \
                "logging.level.org.springframework.web.servlet.mvc.method.annotation=TRACE" # printout REST endpoints at startup \
                "logging.level.org.springframework=DEBUG" \
                "logging.level.org.springframework.boot.autoconfigure=DEBUG" \
                "+++ Tomcat +++" \
                "logging.group.tomcat=org.apache.catalina,org.apache.coyote,org.apache.tomcat" \
                "logging.level.tomcat=DEBUG" \
                "+++ SQL and JPA +++"
                "logging.level.sql=DEBUG" \
                "logging.level.sql=TRACE" \
                "spring.jpa.show-sql=true" \
                "logging.level.org.springframework.jdbc.core=TRACE" \
                "logging.level.org.hibernate=DEBUG" \
                "logging.level.org.springframework.test.context.jdbc=DEBUG" \
                "logging.level.org.springframework.jdbc.datasource.init=DEBUG" \
                "spring.jpa.hibernate.ddl-auto=validate" \
                "+++ Metrics +++"
                "management.endpoints.web.exposure.include=*" # prometheus endpoint (requires prometheus dependency in maven pom!) \
                "management.metrics.export.prometheus.enabled=true" \
                "management.metrics.web.server.request.autotime.enabled=true" # Web MVC metrics \
                "management.metrics.distribution.percentiles-histogram.http.server.requests=true" \
                "management.metrics.enable.jvm=true" \
                "+++ DB stats +++" \
                "spring.jpa.properties.hibernate.generate_statistics=true" \
                "logging.level.org.hibernate.stat=DEBUG" \
                "spring.jpa.properties.hibernate.session.events.log.LOG_QUERIES_SLOWER_THAN_MS=1" \
                "logging.level.org.hibernate.SQL=DEBUG" \
                "logging.level.org.hibernate.cache=DEBUG")
      concatenated=$(printf "%s\n" "${my_array[@]}")
      selectItem 'printf "%s\n" "${my_array[@]}"' "awk '{print \$1}'"
      if [[ $fname == "" ]]; then break; fi
      completeargs="${completeargs},--${fname}"
      redLog "${completeargs#?}"
   done
   completeargs=${completeargs#?}
   blueLog "$completeargs"
   IFS=',' read -r -a args_array <<< "$completeargs"
   IFS="," echo "${args_array[*]}"
   IFS=',' SPRING_PROFILES_ACTIVE="$defprofiles" mvn spring-boot:run -Dspring-boot.run.arguments="${args_array[*]}"
   IFS=' '
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

runJmx() {
   echo "Which profile?"
   read defprofiles
   SPRING_PROFILES_ACTIVE="$defprofiles" mvn spring-boot:run -Dspring-boot.run.jvmArguments="-Xverify:none -Xdebug -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.rmi.port=9010 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=localhost"
}

printActuatorMappings() {
   echo "Port?"
   read mappingsport
   executeCommand "curl http://localhost:"$mappingsport"/actuator | jq -r '._links | .[] | .href'"
}

printMappings() {
   echo "Port?"
   read mappingsport
   curl http://localhost:${mappingsport}/actuator/mappings | jq -r '.contexts | to_entries[] | .value.mappings.dispatcherServlets.dispatcherServlet[] | "\u001b[33m\(.predicate)\u001b[0m \(.handler)"'
}

