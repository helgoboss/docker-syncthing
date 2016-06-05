#!/bin/bash

CONFIG_FOLDER="/root/.config/syncthing"
CONFIG_FILE="$CONFIG_FOLDER/config.xml"

if [ ! -f "$CONFIG_FILE" ]; then
    syncthing -generate="$CONFIG_FOLDER"
    export LOCAL_DEVICE_ID=`xmlstarlet select --template --value-of /configuration/device/@id $CONFIG_FILE`
    export GUI_API_KEY=`xmlstarlet select --template --value-of /configuration/gui/apikey $CONFIG_FILE`
    confd -onetime -backend env
fi

exec syncthing --gui-address="0.0.0.0:8384"