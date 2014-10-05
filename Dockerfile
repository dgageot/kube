FROM dgageot/gcloud
MAINTAINER David Gageot <david@gageot.net>

# Install Go
#
RUN apt-get update -y && apt-get install --no-install-recommends -y -q curl build-essential ca-certificates git mercurial bzr
RUN mkdir /goroot && curl https://storage.googleapis.com/golang/go1.3.linux-amd64.tar.gz | tar xvzf - -C /goroot --strip-components=1
RUN mkdir /gopath

ENV GOROOT /goroot
ENV GOPATH /gopath
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

# Install Kubernetes
#
RUN mkdir /kube
RUN wget -q -O - https://github.com/GoogleCloudPlatform/kubernetes/archive/2978c9923ed1ce0cc9c77bdd173896a8d0d85031.tar.gz | tar xzf - -C /kube --strip-components=1
RUN /kube/hack/build-go.sh

# List pods by default
#
CMD ["/kube/cluster/kubecfg.sh", "list", "pods"]
