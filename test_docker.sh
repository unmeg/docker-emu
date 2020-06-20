#/bin/bash

echo "Does this return a MIPS architecture?!"
sudo docker run -it --rm multiarch/debian-debootstrap:mips-jessie uname -m
