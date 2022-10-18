# dockerfile to build image for JBoss EAP 7.3

#This is docker file based on the jboss eap 7.3 image

#FROM registry.access.redhat.com/ubi8/openjdk-11:1.11-2.1645811224
#FROM registry.redhat.io/ubi8/ubi:latest

FROM openjdk:11

ARG JBOSS_HOME=/data/jboss/eap/

# COPY jboss-eap-7.3.zip $JBOSS_HOME

USER root

# enabling sudo group
# enabling sudo over ssh
RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
sed -i 's/.*requiretty$/Defaults !requiretty/' /etc/sudoers

# create workdir
RUN mkdir -p /data/jboss/eap
WORKDIR /data/jboss/eap

# Download fuse-karaf binaries from artifactory
#RUN curl -u "svc-lma-remediation:Wg^65#mjn((" https://artifactory.dxc.com/artifactory/lma-xag-generic/XSB-DRI/fuse-karaf.zip --output #/opt/jboss/jboss—fuse—karaf.zip
#RUN curl -u svc-lma-remediation:Wg^65#mjn\( https://artifactory.dxc.com/artifactory/lma-xag-generic/XSB-DRI/fuse-karaf-7.5.0.zip --output #/opt/jboss/jboss—fuse—karaf.zip

#RUN curl -u "svc-lma-docker:N2dHHL7qWNX" https://artifactory.dxc.com:443/artifactory/lmcp-devsecops/packages/jboss-eap/7.3.0/jboss-eap.zip --output /data/jboss/eap/jboss-eap-7.3.zip



# add a user for the application, with sudo permissions
RUN useradd -m jboss ; echo jboss:

# install JBoss EAP 7.3.0
ADD jboss-eap-7.3.zip /tmp/jboss-eap-7.3.zip
RUN unzip /tmp/jboss-eap-7.3.zip

# set environment
ENV JBOSS_HOME /data/jboss/eap/jboss-eap-7.3
ENV APP=$APPNAME

# create JBoss console user
RUN $JBOSS_HOME/bin/add-user.sh admin admin --silent
# configure JBoss
RUN echo "JAVA_OPTS=\"\$JAVA_OPTS -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0\"" >> $JBOSS_HOME/bin/standalone.conf


# set permission folder
RUN chown -R jboss:jboss /data/jboss/eap

# JBoss ports
#EXPOSE 8080 9990 9999

# start JBoss
#ENTRYPOINT $JBOSS_HOME/bin/standalone.sh -c standalone-full-ha.xml

ADD standalone-openshift-lma.xml "$JBOSS_HOME/standalone/configuration/"
ENTRYPOINT $JBOSS_HOME/bin/standalone.sh -c standalone-openshift-lma.xml

# deploy app
ADD spring-jboss-0.0.1-SNAPSHOT.war "$JBOSS_HOME/standalone/deployments/"
#ADD ${APP} "$JBOSS_HOME/standalone/deployments/"
#ADD dbload.ear "$JBOSS_HOME/standalone/deployments/"
#ADD xsh-eaccounts-ear-0.0.1-SNAPSHOT.ear "$JBOSS_HOME/standalone/deployments/"
#ADD apixapp.ear "$JBOSS_HOME/standalone/deployments/"
#ADD APIX.war "$JBOSS_HOME/standalone/deployments/"
#ADD xsh-ear-0.0.1-SNAPSHOT.ear "$JBOSS_HOME/standalone/deployments/"
#ADD springboot-swagger-test-0.0.1-SNAPSHOT.war "$JBOSS_HOME/standalone/deployments/"

USER root

RUN chown jboss:jboss "$JBOSS_HOME/standalone/deployments/${APP}"

# Important, use jboss user to run image
USER jboss

## COPY EXT JAR and MODULE TO SERVER
ADD com/thoughtworks/xstream/XStream/main/xstream-1.4.17.jar "$JBOSS_HOME/modules/com/thoughtworks/xstream/XStream/main/"
ADD com/oracle/jdbc/main/ojdbc8-21.1.0.0.jar "$JBOSS_HOME/modules/com/oracle/jdbc/main/"
COPY com/thoughtworks/xstream/XStream/main/module.xml "$JBOSS_HOME/modules/com/thoughtworks/xstream/XStream/main/"
COPY com/oracle/jdbc/main/module.xml "$JBOSS_HOME/modules/com/oracle/jdbc/main/"

#RUN ["/opt/eap/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c","standalone-openshift-lma.xml"]

#CMD /bin/bash

#CMD ["/opt/eap/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c","standalone-openshift-lma.xml"]

#RUN $JBOSS_HOME/bin/jboss-cli.sh --commands="connect","/core-service=management/management-interface=http-interface:write-attribute(name=console-enabled,value=true)"

CMD ["$JBOSS_HOME/bin/jboss-cli.sh  /core-service=management/management-interface=http-interface:write-attribute(name=console-enabled,value=true)"]

#CMD ["$JBOSS_HOME/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c","standalone-openshift-lma.xml"]

CMD ["$JBOSS_HOME/bin/standalone.sh", "-c", "standalone-full.xml", "-b", "0.0.0.0","-bmanagement","0.0.0.0"] 

#RUN rm jboss-eap-7.4.zip


# add a user for the application
#RUN /opt/eap/bin/add-user.sh adminUser StrongPassword#1 --silent


# Copy war to deployments folder
#COPY xsh-ear-0.0.1-SNAPSHOT.ear $JBOSS_HOME/standalone/deployments/
#COPY ${APP} /opt/eap/standalone/deployments/
#COPY app.war $JBOSS_HOME/standalone/deployments/

# User root to modify war owners
#USER root

# Modify owners war/ear
#RUN chown jboss:jboss $JBOSS_HOME/standalone/deployments/xsh-ear-0.0.1-SNAPSHOT.ear
#RUN chown jboss:jboss /opt/eap/standalone/deployments/${APP}
#RUN chown jboss:jboss $JBOSS_HOME/standalone/deployments/app.war

# Important, use jboss user to run image
#USER jboss

## COPY XStream MODULE TO SERVER
#ADD com/thoughtworks/xstream/XStream/main/xstream-1.4.17.jar /opt/eap/modules/com/thoughtworks/xstream/XStream/main/
#ADD com/oracle/jdbc/main/ojdbc8-21.1.0.0.jar /opt/eap/modules/com/oracle/jdbc/main/


## COPY EXT MODULE TO SERVER
#ADD module.xml $JBOSS_HOME/modules/com/thoughtworks/xstream/XStream/main/
#ADD standalone-openshift-lma.xml /opt/eap/standalone/configuration/
#COPY com/thoughtworks/xstream/XStream/main/module.xml /opt/eap/modules/com/thoughtworks/xstream/XStream/main/
#COPY com/oracle/jdbc/main/module.xml /opt/eap/modules/com/oracle/jdbc/main/


# Set the default command to run on boot . This will boot eap in standalone mode and bind to all interfaces 

#CMD ["/opt/eap/bin/standalone.sh --server-config=standalone-openshift.xml", "-b", "0.0.0.0"]

#CMD ["/opt/eap/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c","standalone-openshift-lma.xml"]

#CMD ["/opt/eap/bin/jboss-cli.sh  /core-service=management/management-interface=http-interface:write-attribute(name=console-enabled,value=true)"]

#CMD ["/opt/eap/bin/jboss-cli.sh -c --command="module add --name=com.thoughtworks.xstream.XStream --resources=$JBOSS_HOME/modules/com/thoughtworks/xstream/XStream/main/xstream-1.4.17.jar""]
