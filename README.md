# Jenkins in Kubernetes
This repo package Jenkins and other software, 
such as: maven, docker, nodejs, kubectl, helm v3
and other Jenkins plugins, see [plugins.txt](plugins.txt)

This Jenkins has the required tools to work in and with Kubernetes
- Jenkins' application with pre-loaded plugins (see [plugins.txt](plugins.txt))
- Skipped setup wizard
  - You can control admin user and password with `-e ADMIN_USER=<your_admin_user> -e ADMIN_PASSWORD=<password>`
  - You can add and remove plugins by editing the [plugins.txt](plugins.txt) file
- Docker for managing a Docker CI lifecycle
- `kubectl` command line client for working with the Kubernetes API
  **should mount `kube config` file to use `kubectl`

### pull the Docker image
You can pull an already built version of this Jenkins image from `docker hub`.
```bash
# Pull the image
$ docker pull imwower/jenkins-in-kubernetes
```

### Build the Jenkins Docker image
You can build the image yourself
```bash
$ git clone https://github.com/imwower/jenkins-in-kubernetes.git

# Build the image
$ docker build -t jenkins -f Dockerfile \
    --build-arg NODE_VERSION="14.x" \
    --build-arg KUBECTL_VERSION="v1.20.1" \
    --build-arg HELM_VERSION="v3.3.4" \
    .

# Push the image
$ docker push jenkins
```

### run image using Docker
You can run your container locally, if you have Docker installed

```bash
$ docker run -d --name jenkins -p 8080:8080 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /<your_jenkins_path>:/var/jenkins_home \
    -v /<your_maven_m2_path>:/root/.m2 \
    -v /<your_k8s_config_file>:/root/.kube/config \
    -e ADMIN_USER=<your_admin_user> \
    -e ADMIN_PASSWORD=<password>
    jenkins

```

- Browse to http://localhost:8080 on your local browser

### Use maven docker nodejs kubectl helm...
```bash
$ mvn -v
$ node -v
$ npm -v
$ docker -v
$ kubectl version
$ helm version
```
