#!/usr/bin/env bash

# determine system arch
ARCH=
if [ "$(uname -m)" == 'x86_64' ]
then
    ARCH=amd64
elif [ "$(uname -m)" == 'aarch64' ]
then
    ARCH=arm64
elif [ "$(uname -m)" == 'i386' ] || [ "$(uname -m)" == 'i686' ]
then
    ARCH=386
else
    ARCH=arm
fi

ARCHIVE=ngrok-v3-stable-linux-$ARCH.zip
DOWNLOAD_URL=https://bin.equinox.io/c/bNyj1mQVY4c/$ARCHIVE

sudo apt install wget unzip jq -y
wget https://raw.githubusercontent.com/lamtota40/tes/main/ngrok.yml
clear
echo "Downloading ngrok for $ARCH . . ."
wget $DOWNLOAD_URL
unzip $ARCHIVE
chmod +x ngrok
./ngrok service install --config=ngrok.yml
./ngrok service start
echo -e "Finish… to check status NGROK visit \n http://127.0.01:4040"
