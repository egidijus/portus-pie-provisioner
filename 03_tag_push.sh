#!/bin/bash
# this script is used to tag the images you built
# then it pushes to the docker registry you have defined
# the docker tag version is incremented every time you run this.
#
#
#
#
#
#
#


file="./docker_tag"
COUNTER=$(cat "$file")
echo "old docker tag $COUNTER"

COUNTER=$((COUNTER+1))
echo "$COUNTER" > $file

echo "new docker tag $COUNTER"
docker tag portus-portus your-old-registry.com/portus-portus:$COUNTER
docker tag portus-registry your-old-registry.com/portus-registry:$COUNTER
docker tag portus-nginx your-old-registry.com/portus-nginx:$COUNTER

docker push your-old-registry.com/portus-portus:$COUNTER
docker push your-old-registry.com/portus-registry:$COUNTER
docker push your-old-registry.com/portus-nginx:$COUNTER
