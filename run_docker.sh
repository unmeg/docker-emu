#!/bin/bash

# AWFUL DOCKER SCRIPTS FOR TERRIBLE FIRMWARE EMULATION
# IMPLEMENTATION HANDLED BY ME, MEG WHITE
# IDEA STOLEN FROM Ilya @ https://www.youtube.com/watch?v=N0EYsO0VxZo

# This script will run your docker container I guess!??!!

CONTAINER_NAME="test_mips"

echo "Running container.."

# sudo docker run -it $CONTAINER_NAME:latest /bin/sh
sudo docker run --rm --cap-add SYS_PTRACE -p 80:80 -p 23:23 -p 7777:7777 -i -t $CONTAINER_NAME:latest /bin/sh
