#!/bin/bash

# AWFUL DOCKER SCRIPTS FOR TERRIBLE FIRMWARE EMULATION
# IMPLEMENTATION HANDLED BY ME, MEG WHITE
# IDEA STOLEN FROM Ilya @ https://www.youtube.com/watch?v=N0EYsO0VxZo

# This script will build your Dockerfile and then the image!

BASE_DIR=`pwd`
FIRMWARE_NAME=firmware
EXTRACTED_FIRMWARE_NAME=firmware.tar.gz
FIRMWARE_LOC=$BASE_DIR/$FIRMWARE_NAME.zip
EXTRACTED_FIRMWARE_LOC=$BASE_DIR/outputs/firmware.tgz
DOCKERFILE_LOC=$BASE_DIR/Dockerfile
CONTAINER_NAME="test_mips"

echo "Don't forget to put any extra binaries/similar into the addons folder!"
echo "If you do this, the Dockerfile will be made to automatically copy them over to the container."
echo "For example, putting an appropriate GDB server binary in there would be a good idea!"
echo ""

echo "Making Dockerfile!"
echo ""
if [ -e $DOCKERFILE_LOC ]; then
    echo "File $DOCKERFILE_LOC already exists!"
else
    echo "FROM multiarch/debian-debootstrap:mips-buster-slim as qemu" >> $DOCKERFILE_LOC
    echo "FROM scratch" >> $DOCKERFILE_LOC
    echo "ADD ./outputs/$EXTRACTED_FIRMWARE_NAME /" >> $DOCKERFILE_LOC
    echo "COPY --from=qemu /usr/bin/qemu-mips-static /usr/bin" >> $DOCKERFILE_LOC
    for fyle in $(ls $BASE_DIR/addons); do echo "COPY ./addons/$fyle /tmp/from_host/" >> $DOCKERFILE_LOC;done
    echo 'CMD ["/usr/bin/qemu-mips-static", "bin/busybox"]' >> $DOCKERFILE_LOC
    echo "ENV ARCH=mips" >> $DOCKERFILE_LOC
fi

echo "Building container.."
echo ""
sudo docker build --rm -t $CONTAINER_NAME --file $DOCKERFILE_LOC .

# bugfix for mips files
echo "Fixing MIPS bug"
echo -1 > /proc/sys/fs/binfmt_misc/qemu-mipsn3
echo -1 > /proc/sys/fs/binfmt_misc/qemu-mipsn32el
