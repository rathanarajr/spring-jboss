
REM SET APPLICATION_PATH=%1
SET IMAGE_NAME=%1     
REM WORKING SET CONTAINER_PORT=%3
SET APPNAME=%2
REM WORKING SET APPPATH=%5
REM SET DOCKER_REGISTRY_URL_HUB=""
SET DOCKER_USER_LOCAL="rathandocker"
SET DOCKER_PASSWORD_LOCAL="Rathan@docker1"



REM SET URL="http://localhost:%CONTAINER_PORT%/spring-jboss-0.0.1-SNAPSHOT/hello"

CD b2i

rem docker build --tag %IMAGE_NAME% .

REM docker build --tag rathandocker/sampleeap74:1.0 .

REM docker build --tag %IMAGE_NAME% .

rem spring-jboss-0.0.1-SNAPSHOT.war

REM WORKING COPY %APPPATH%

REM docker login ${DOCKER_REGISTRY_URL_HUB} -u ${DOCKER_USER_LOCAL} -p ${DOCKER_LOCAL_PASSWORD}'

docker login -u %DOCKER_USER_LOCAL% -p %DOCKER_PASSWORD_LOCAL%'

docker build --tag %IMAGE_NAME% --build-arg appname=%APPNAME% .

REM docker build --tag samp --build-arg appname=spring-jboss-0.0.1-SNAPSHOT .

REM docker build --tag %IMAGE_NAME% --build-arg appname=spring-jboss-0.0.1-SNAPSHOT.war .

rem docker run -d -p %CONTAINER_PORT%:%CONTAINER_PORT% %IMAGE_NAME%

REM docker run -d -p 8080:8080 -p 9990:9990 %IMAGE_NAME%

REM WORKING docker run -d -p %CONTAINER_PORT%:%CONTAINER_PORT% -p 9990:9990 %IMAGE_NAME%

docker run -d -p 8880:8080 %IMAGE_NAME%

REM docker ps --filter status=running

REM docker save -o . %IMAGE_NAME%

REM WORKING start chrome %URL%

