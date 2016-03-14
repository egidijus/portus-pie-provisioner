#!/bin/sh

unset `env | grep affinity | awk -F= '/^\w/ {print $1}' | xargs`
/usr/bin/pongo-blender /etc/pongo-blender/config.yml.tmpl > /etc/docker-registry/config.yml

chown -R $PROJECT_NAME:$PROJECT_NAME /etc/docker-registry
gosu $PROJECT_NAME docker-registry /etc/docker-registry/config.yml
