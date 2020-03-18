#!/bin/sh

if test "$EUID" -ne 0
then
        echo "Please run with sudo"
        exit 1
fi

# Build
docker build -t $HOSTNAME/blender_nantille:28 .

# Copy on host's current folder
docker run $HOSTNAME/blender_nantille:28
docker cp $(docker ps -a | grep nantille | awk '{print $1}'):/home/blender_28_mod-x86_64.tar.gz ./

# Throwaway the container and the related blender image
# Note: base CentOS image is not removed
docker rm $(docker ps -a | grep nantille | awk '{print $1}')
docker rmi $(docker images | grep nantille | awk '{print $3}')