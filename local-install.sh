#!/bin/bash

source .env

source bash-common

APP_DIR=".config/$APP_NAME"

cd ~

if [ -d "$APP_DIR" ] && [ ! -f "$APP_DIR/data/version" ]; then
    error "Already found app directory. Installation will be aborted"
fi

mkdir "$APP_DIR"

chmod 700 .config # keep enforce this

for dir in log data; do
    mkdir "$APP_DIR/$dir"
    
chmod -R 600 "$APP_DIR"
