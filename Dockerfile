FROM golang:1.6.2

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y git curl jq xmlstarlet && \
    rm -rf /var/lib/apt/lists/*

RUN VERSION=`curl -s https://api.github.com/repos/syncthing/syncthing/releases/latest | jq -r '.tag_name'` && \
    mkdir -p /go/src/github.com/syncthing && \
    cd /go/src/github.com/syncthing && \
    git clone https://github.com/syncthing/syncthing.git && \
    cd syncthing && \
    git checkout $VERSION && \
    go run build.go && \
    mv bin/syncthing /root/syncthing && \
    rm -rf /go/src/github.com/syncthing

ADD start.sh /start.sh
RUN chmod +x /start.sh

ADD https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 /bin/confd
RUN chmod +x /bin/confd
ADD confd /etc/confd

WORKDIR /root

VOLUME ["/root/.config/syncthing"]

EXPOSE 8384 22000 21025/udp

CMD ["/start.sh"]