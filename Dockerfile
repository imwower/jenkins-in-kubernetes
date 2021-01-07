FROM jenkins/jenkins:lts

ARG NODE_VERSION=14.x
ARG KUBECTL_VERSION=v1.20.1
ARG HELM_VERSION=v3.3.4

# Running as root to have an easy support for Docker
USER root

# A default admin user
ENV ADMIN_USER=admin \
    ADMIN_PASSWORD=password

# Jenkins init scripts
COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/

# Install plugins at Docker image build time
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh $(cat /usr/share/jenkins/plugins.txt) && \
    mkdir -p /usr/share/jenkins/ref/ && \
    echo lts > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state && \
    echo lts > /usr/share/jenkins/ref/jenkins.install.InstallUtil.lastExecVersion

# Install Docker and maven
RUN apt-get update && \
    apt-get -y install maven && \
    apt-get -y install curl && \
    curl -sSL https://get.docker.com/ | sh
    
RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION | sh -
RUN apt-get install -y nodejs

# Install kubectl
RUN curl -LO https://dl.k8s.io/$KUBECTL_VERSION/kubernetes-client-linux-amd64.tar.gz && \
    tar -xzvf kubernetes-client-linux-amd64.tar.gz && \
    mv kubernetes/client/bin/kubectl /usr/bin/ && \
    chmod +x /usr/bin/kubectl

# Install helm
RUN curl -o helm.tar.gz -L https://get.helm.sh/helm-$HELM_VERSION-linux-amd64.tar.gz && \
    tar -xzvf helm.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/ && \
    chmod +x /usr/local/bin/helm