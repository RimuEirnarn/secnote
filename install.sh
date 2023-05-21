#!/bin/sh


source .env
source bash-common

APP_DIR="/var/local/data/$APP_NAME"

if [ ! $UID = 0 ]; then
    error "Installation can be done as root.\nLocal install should use local-install.sh"
fi

id $APP_UID | grep "uid=$APP_UID($APP_NAME)" 2> /dev/null > /dev/null
if [ $? = 0 ]; then
    error "The user 612 already exists and is not the application name."
fi

[ ! -d "$APP_DIR" ] && mkdir -p "$APP_DIR"

adduser --uid $APP_UID --home "$APP_DIR" --system --disabled-login --no-create-home
