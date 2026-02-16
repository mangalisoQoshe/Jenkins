ARG DOCKER_GID=984

FROM jenkins/jenkins:2.541.1-jdk21

USER root

RUN groupadd -g ${DOCKER_GID} docker && usermod -aG docker jenkins 
USER jenkins

RUN jenkins-plugin-cli --plugins "blueocean docker-workflow json-path-api"