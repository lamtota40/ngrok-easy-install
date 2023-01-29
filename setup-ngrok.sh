#!/usr/bin/env bash

# determine system arch
#sudo apt install ufw
#sudo ufw status
#ufw status verbose
#https://dl.equinox.io/ngrok/ngrok-v3/stable

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
lock1=/var/lib/dpkg/lock-frontend
lock2=/var/lib/dpkg/lock
lock3=/var/cache/apt/archives/lock

sudo kill -9 $(lsof -t $lock1) | rm $lock1
sudo kill -9 $(lsof -t $lock2) | rm $lock2
sudo kill -9 $(lsof -t $lock3) | rm $lock3
sudo dpkg --configure -a
sudo apt update
exit 1

sudo apt-get install openssh-server -y
sudo apt-get install jq -y
#sudo apt-get install curl -y
sudo apt-get install unzip jq -y
wget https://raw.githubusercontent.com/lamtota40/ngrok-easy-install/main/ngrok.yml
wget $DOWNLOAD_URL
unzip $ARCHIVE
sudo chmod +x ngrok
clear
echo "Running ngrok for $ARCH . . ."
./ngrok service install --config=ngrok.yml
sleep 3
./ngrok service start
echo "Wait 15s…"
sleep 15
echo -e "Finish… to check status NGROK: \n http://127.0.01:4040"
echo -e "To stop service NGROK:\n ./ngrok service stop"
echo -e "To setting configuration:\n ngrok.yml"
echo -e "To change authtoken:\n ./ngrok config add-authtoken 2J8ncba…"
#if [ ! $(which jq) ]; then
#    echo 'Please install git package'
#    exit 1
#fi

STATUSNGROK=$(wget -q http://127.0.0.1:4040/api/tunnels | jq '.tunnels | .[] | "\(.name) \(.public_url)"')
echo -e "service online NGROK:\n" $STATUSNGROK
