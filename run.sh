#!/bin/bash
#
# Run JMeter Docker image with options

NAME="jmeter"
JMETER_VERSION=${JMETER_VERSION:-"5.4"}
IMAGE="alrosa3/jmeter:${JMETER_VERSION}"
JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}
JMETER_BIN=${JMETER_HOME}/bin
# Finally run
docker run --rm --name ${NAME}$2 -i -v ${PWD}:${JMETER_BIN}/project -w ${JMETER_BIN}/project ${IMAGE} $@
