# dockerfile to build image for JBoss EAP 7.3

FROM openjdk:11

# file author / maintainer
MAINTAINER "FirstName LastName" "emailaddress@gmail.com"

# enabling sudo group
# enabling sudo over ssh
RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
sed -i 's/.*requiretty$/Defaults !requiretty/' /etc/sudoers

# add a user for the application, with sudo permissions
RUN useradd -m jboss ; echo jboss: | chpasswd ; usermod -a -G jboss jboss

# create workdir
RUN mkdir -p /data/eap/

WORKDIR /data/eap/

# install JBoss EAP 6.4.0
ADD jboss-eap-7.3.zip /data/eap/jboss-eap-7.3.zip
RUN unzip /data/eap/jboss-eap-7.3.zip

# set environment
ENV JBOSS_HOME /data/eap/jboss-eap-7.3

# create JBoss console user
RUN $JBOSS_HOME/bin/add-user.sh admin admin@2016 --silent
# configure JBoss
RUN echo "JAVA_OPTS=\"\$JAVA_OPTS -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0\"" >> $JBOSS_HOME/bin/standalone.conf

# set permission folder
RUN chown -R jboss:jboss /data/eap/

# JBoss ports
EXPOSE 8080 9990 9999

# start JBoss
ENTRYPOINT $JBOSS_HOME/bin/standalone.sh -c standalone-full-ha.xml

# deploy app
ADD spring-jboss-0.0.1-SNAPSHOT.war "$JBOSS_HOME/standalone/deployments/"

USER jboss
CMD /bin/bash
