# Build:
#   docker build -t dgageot/kube .
#
# Run:
#   docker run --rm -ti --volumes-from gcloud-config -v $HOME/.kubernetes_auth:/root/.kubernetes_auth dgageot/kube list pods

# DOCKER_VERSION 1.2

FROM dgageot/gcloud
MAINTAINER David Gageot <david@gageot.net>

# Install Go
#
RUN apt-get update && apt-get install -y \
  --no-install-recommends \
  build-essential \
  bzr \
  ca-certificates \
  git \
  mercurial

RUN mkdir /goroot \
    && wget -qO - https://storage.googleapis.com/golang/go1.3.2.linux-amd64.tar.gz \
    | tar xzf - -C /goroot --strip-components=1
RUN mkdir /gopath

ENV GOROOT /goroot
ENV GOPATH /gopath
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

# Install Kubernetes
#
RUN mkdir /kube
RUN wget -q -O - https://github.com/GoogleCloudPlatform/kubernetes/archive/2978c9923ed1ce0cc9c77bdd173896a8d0d85031.tar.gz \
    | tar xzf - -C /kube --strip-components=1
RUN /kube/hack/build-go.sh

ENTRYPOINT ["/kube/cluster/kubecfg.sh"]
