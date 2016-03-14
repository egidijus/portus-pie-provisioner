#!/bin/sh

unset `env | grep affinity | awk -F= '/^\w/ {print $1}' | xargs`

DATE=`/bin/date +%Y-%m-%d-%H:%M:%S`

setup_database() {
  set +e

  TIMEOUT=90
  COUNT=0
  RETRY=1

  while [ $RETRY -ne 0 ]; do
    if [ "$COUNT" -ge "$TIMEOUT" ]; then
      printf " [FAIL]\n"
      echo "Timeout reached, exiting with error"
      exit 1
    fi
    echo "Waiting for mariadb to be ready in 5 seconds"
    sleep 5
    COUNT=$((COUNT+5))

    printf "Portus: configuring database... \n"
    # primary rake
    #gosu portus rake db:setup
    bundle exec rake db:migrate:reset db:seed
     # &> /dev/null
    # alternative rake
    #docker-compose run --rm portus sh -c "rake db:create && rake db:migrate && rake db:seed &> /dev/null"

    RETRY=$?
    if [ $RETRY -ne 0 ]; then
        printf " failed, will retry\n"
    fi
  done
  printf " [SUCCESS]\n"
  set -e
}


chown -R $PROJECT_NAME:$PROJECT_NAME /$PROJECT_NAME

pongo-blender /portus/pongo/config.yml.tmpl > /portus/config/config.yml
pongo-blender /portus/pongo/config.yml.tmpl > /portus/config/config-local.yml
pongo-blender /portus/pongo/secrets.yml.tmpl > /portus/config/secrets.yml
pongo-blender /portus/pongo/database.yml.tmpl > /portus/config/database.yml

chown -R $PROJECT_NAME:$PROJECT_NAME /$PROJECT_NAME

# start cron container `entrypoint.sh crono`
# `docker run -it portus crono`
if [ "$1" == "crono" ]; then
    echo "${DATE}"
    echo "i am el crono-holio"

    gosu portus bundle exec crono
    exit 0
fi

# start main application container `entrypoint.sh web`
# `docker run -it portus web`
if [ "$1" == "web" ]; then
    echo "${DATE}"
    echo "i am el web-servidor"
    gosu portus puma -b tcp://0.0.0.0:3000 -w 3 -e production
    exit 0
fi

# start migrator container `entrypoint.sh migrate`
# `docker run -it portus migrate`
if [ "$1" == "migrate" ]; then
    echo "${DATE}"
    echo "i am el migratore"
    setup_database
    exit 0
fi

exec "$@"

