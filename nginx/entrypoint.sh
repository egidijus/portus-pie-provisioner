#!/bin/sh
mkdir -p /etc/nginx/sites-enabled/
mkdir -p /var/log/nginx
mkdir -p /var/nginx-cache

chown -R $PROJECT_NAME /var/log/nginx
chgrp -R $PROJECT_NAME /var/log/nginx
chmod -R 0775 /var/log/nginx

chown -R $PROJECT_NAME /var/nginx-cache
chgrp -R $PROJECT_NAME /var/nginx-cache
chmod -R 0775 /var/nginx-cache

unset `env | grep affinity | awk -F= '/^\w/ {print $1}' | xargs`
/usr/bin/pongo-blender /etc/pongo-blender/nginx.conf.tmpl > /etc/nginx/nginx.conf
/usr/bin/pongo-blender /etc/pongo-blender/site.conf.tmpl > /etc/nginx/sites-enabled/site.conf
/usr/bin/pongo-blender /etc/pongo-blender/mime.types > /etc/nginx/mime.types

chown -R $PROJECT_NAME /var/lib/nginx
chgrp -R $PROJECT_NAME /var/lib/nginx
chmod -R 755 /var/lib/nginx

nginx
