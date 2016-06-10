#!/bin/bash

CONFIG_FOLDER="/root/.config/syncthing"
CONFIG_FILE="$CONFIG_FOLDER/config.xml"

if [ ! -f "$CONFIG_FILE" ]; then
    syncthing -generate="$CONFIG_FOLDER"
    export LOCAL_DEVICE_ID=`xmlstarlet select --template --value-of /configuration/device/@id $CONFIG_FILE`
    export GUI_API_KEY=`xmlstarlet select --template --value-of /configuration/gui/apikey $CONFIG_FILE`
    : ${DEVICE_NAME:=`curl http://rancher-metadata/2015-12-19/self/host/hostname`}
    : ${DEVICE_IP:=`curl http://rancher-metadata/2015-12-19/self/host/agent_ip`}
    confd -onetime -backend env
fi

exec syncthing