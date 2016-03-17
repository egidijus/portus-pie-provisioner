# portus-pie-provisioner

This set of scripts and dockerfiles should setup a portus service on a single host with docker.
This config is designed to be used with wildcard or multi-sub-domain ssl certificates.
You should have one certificate for `*.yourdomain.com` the certificate should be "bundled" so it works with nginx.

The final solutions is 
portus URL = `portus.yourdomain.com` for portus UI

docker URL = `docker.yourdomain.com` for docker login and docker registry


## Requirements

* bash
* docker (current version)
* docker-compose (for local dev/build)


## Quickstart

* Update secrets and configs in the below files to match your configuration
```
---
nginx/ssl_crt.crt
nginx/ssl_key.key


---
portus/ssl_key.key
portus/pongo/config.yml.tmpl
portus/pongo/database.yml.tmpl
portus/pongo/secrets.yml.tmpl


registry/config.yml.tmpl
registry/ssl_crt.crt

docker-compose.yml
```
 * Run `01_start_config.sh` on your linux host
You should end up with a working portus system.





## Other things


tools.sh is a script for use inside the containers, if you want to troublshoot things.
```
docker exec -it portus-web ash
```
then
```
tools
```
to install basic utilities for troubleshooting things




`pongo-blender` is a go application for parsing jinja2 style templates and injecting environment vars.
This is how we create our configuration at run time.


`gosu` is a go application for running things as a different user.

`02_run_again.sh` is for testing your config, if you changed some values but do not want to delete database or run database migrations.

`03_tag_push.sh` is for tagging and pushing your docker images to docker registry.





