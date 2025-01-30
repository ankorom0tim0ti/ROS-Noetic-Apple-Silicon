#!/bin/bash

# Check SSH key
if [ ! -f ~/.ssh/id_rsa ] && [ ! -f ~/.ssh/id_ed25519 ]; then
    echo "ERROR: SSH key not found!"
    echo "~/.ssh/id_rsa or ~/.ssh/id_ed25519 is needed!"
    exit 1
fi

# Stop and delete the container
docker stop ros1_noetic 2>/dev/null || true
docker rm ros1_noetic 2>/dev/null || true

# Allow X server connections
xhost +local:docker

# Run the container
docker run -it \
    --privileged \
    --name ros1_noetic \
    --net=host \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$HOME/ros1/noetic-docker/noetic:/root/noetic" \
    --volume="$HOME/.ssh:/root/.ssh:ro" \
    --device-cgroup-rule='c 81:* rmw' \
    --device-cgroup-rule='c 189:* rmw' \
    --device=/dev/bus/usb:/dev/bus/usb \
    --volume="/dev:/dev" \
    noetic:1.1.0
