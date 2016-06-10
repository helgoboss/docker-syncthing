FROM ubuntu:latest

# Install Syncthing

RUN apt-get update && \
    apt-get install -y curl xmlstarlet && \
    curl -s https://syncthing.net/release-key.txt | apt-key add - && \
    echo deb http://apt.syncthing.net/ syncthing release | tee /etc/apt/sources.list.d/syncthing-release.list && \
    apt-get update && \
    apt-get install -y syncthing

ADD start.sh /start.sh
RUN chmod +x /start.sh

ADD https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 /bin/confd
RUN chmod +x /bin/confd
ADD confd /etc/confd

WORKDIR /root

ENV GUI_BIND_ADDRESS 0.0.0.0

VOLUME ["/root/.config/syncthing"]

EXPOSE 8384 22000 21027/udp

CMD ["/start.sh"]