# inspired by https://github.com/hauptmedia/docker-jmeter  and
# https://github.com/hhcordero/docker-jmeter-server/blob/master/Dockerfile
FROM alpine:3.12

MAINTAINER Just van den Broecke<just@justobjects.nl>

ARG JMETER_VERSION="5.4"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV	JMETER_BIN	${JMETER_HOME}/bin
ENV	JMETER_DOWNLOAD_URL  https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz
ENV JMETER_PLUGINS_DOWNLOAD_URL https://repo1.maven.org/maven2/kg/apc
ENV JMETER_PLUGINS_FOLDER ${JMETER_HOME}/lib/ext/

# Install extra packages
# Set TimeZone, See: https://github.com/gliderlabs/docker-alpine/issues/136#issuecomment-612751142
ARG TZ="Europe/Amsterdam"
ENV TZ ${TZ}
RUN    apk update \
	&& apk upgrade \
	&& apk add ca-certificates \
	&& update-ca-certificates \
	&& apk add --update openjdk8-jre tzdata curl unzip bash \
	&& apk add --no-cache nss \
	&& rm -rf /var/cache/apk/* \
	&& mkdir -p /tmp/dependencies  \
	&& curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
	&& mkdir -p /opt  \
	&& tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
	&& rm -rf /tmp/dependencies

# plugins
# && unzip -oq "/tmp/dependencies/JMeterPlugins-*.zip" -d $JMETER_HOME
RUN curl -L --silent ${JMETER_PLUGINS_DOWNLOAD_URL}/jmeter-plugins-casutg/2.10/jmeter-plugins-casutg-2.10.jar -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-casutg-2.10.jar
RUN curl -L --silent ${JMETER_PLUGINS_DOWNLOAD_URL}/jmeter-plugins-manager/1.6/jmeter-plugins-manager-1.6.jar -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-manager-1.6.jar
RUN curl -L --silent ${JMETER_PLUGINS_DOWNLOAD_URL}/jmeter-plugins-standard/1.4.0/jmeter-plugins-standard-1.4.0.jar -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-standard-1.4.0.jar
# Set global PATH such that "jmeter" command is found
ENV PATH $PATH:$JMETER_BIN

# Entrypoint has same signature as "jmeter" command
COPY entrypoint.sh ${JMETER_BIN}
#COPY jmeter-start-test.sh ${JMETER_BIN}
#COPY profile_run.sh ${JMETER_BIN}
#COPY config/ ${JMETER_BIN}/config
#COPY scripts/ ${JMETER_BIN}/scripts
#COPY jmeter_results2/ ${JMETER_BIN}/jmeter_results2
#COPY results/ ${JMETER_BIN}/results
#COPY prepare/ ${JMETER_BIN}/prepare
#COPY profiles/ ${JMETER_BIN}/profiles
#COPY jmeter_parser_ALL.jar ${JMETER_BIN}


WORKDIR	${JMETER_BIN}
#WORKDIR	/
RUN    pwd
RUN    chmod +x entrypoint.sh
#RUN    chmod +x jmeter-start-test.sh
#RUN    chmod +x profile_run.sh
ENTRYPOINT ["entrypoint.sh"]