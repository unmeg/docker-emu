#!/bin/bash

# AWFUL DOCKER SCRIPTS FOR TERRIBLE FIRMWARE EMULATION
# IMPLEMENTATION HANDLED BY ME, MEG WHITE
# IDEA STOLEN FROM Ilya @ https://www.youtube.com/watch?v=N0EYsO0VxZo

# This script will prepare your box, physically and mentally, for what we're about to do.

BASE_DIR=`pwd`
FIRMWARE_NAME=firmware
# FIRMWARE_LOC=$BASE_DIR/firmware.zip
FIRMWARE_LOC=$BASE_DIR/$FIRMWARE_NAME.zip

echo "Setting up some folders.."
echo ""
mkdir $BASE_DIR/outputs $BASE_DIR/addons

echo "Grabbing some dependencies!"
echo ""
sudo apt-get install qemu binfmt-support qemu-user-static docker.io git zip unzip
# from firmadyne
sudo apt-get install fakeroot python-psycopg2 python3-psycopg2 python-magic
sudo pip3 install python-magic binwalk

# populating binfmt_misc with entries for emulation
echo "Running container in privileged mode because we need to modify the host."
echo ""
sudo docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

git clone https://github.com/devttys0/binwalk.git
cd binwalk
sudo ./deps.sh
sudo python ./setup.py install
sudo python3 ./setup.py install


cd $BASE_DIR

echo "Grabbing firmware extractor!"
echo ""
git clone https://github.com/firmadyne/extractor.git

echo "Running extractor.."
echo ""
cd extractor
#sudo ./extract.sh $FIRMWARE_LOC $BASE_DIR/outputs
fakeroot python3 ./extractor.py -np $FIRMWARE_LOC $BASE_DIR/outputs

cd $BASE_DIR

echo "Doing a dirty hack that could break things if your output directory isn't empty"
mv outputs/$FIRMWARE_NAME*.tar.gz outputs/$FIRMWARE_NAME.tar.gz

echo " >>> Make sure any extra binaries you want copied over to your container are put into the addons folder before you run the next step."
echo ""
echo "When you are ready, run build_docker.sh!"
echo ""
