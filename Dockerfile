FROM maven:3.3.9-jdk-8-alpine
FROM openjdk:18-jdk-slim


LABEL "com.github.actions.name"="backend-deployer"
LABEL "com.github.actions.description"="Github action for deploy Spring boot to Amazon EC2. "
LABEL "com.github.actions.icon"="archive"
LABEL "com.github.actions.color"="orange"

LABEL "maintainer"="Lewandy Diloné Bonifacio <lewandydilone1@live.com>"
LABEL "repository"="https://github.com/leefrank67/backend-deployer"
LABEL version="1.0.0"

#Install utilities
RUN apt-get update && \ 
    apt-get install -y curl procps && \
    apt-get install unzip && \ 
    rm -rf /var/lib/apt/lists/*

ARG MAVEN_VERSION=3.8.6
ARG USER_HOME_DIR="/root"
ARG SHA=f790857f3b1f90ae8d16281f902c689e4f136ebe584aba45e4b1fa66c80cba826d3e0e52fdd04ed44b4c66f6d3fe3584a057c26dfcac544a60b301e6d0f91c26
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

# Install aws cli v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip > /dev/null 2>&1
RUN ./aws/install

ADD entrypoint.sh /entrypoint.sh

#Make entrypoint file executable
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
