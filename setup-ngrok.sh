#!/usr/bin/env bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    echo "You can Try comand 'su root' or 'sudo -i' or 'sudo -'"
    exit 1
fi
sudo apt-get update

if [ ! $(which wget) ]; then
    sudo apt-get install wget -y
fi

if [ ! $(which jq) ]; then
    sudo apt-get install jq -y
fi

#for download manual https://dl.equinox.io/ngrok/ngrok-v3/stable/archive
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

ARCHIVE=ngrok-v3-stable-linux-$ARCH.tgz
DOWNLOAD_URL=https://bin.equinox.io/c/bNyj1mQVY4c/$ARCHIVE

mkdir -p /opt/dirngrok
cd /opt/dirngrok
if [ -f "/opt/dirngrok/ngrok.yml" ];then
    echo "OK…file 'ngrok.yml' Found"
else
    wget https://raw.githubusercontent.com/lamtota40/ngrok-easy-install/main/ngrok.yml --no-check-certificate
fi

if [ -f "/opt/dirngrok/ngrok.service" ];then
    echo "Ok… file 'ngrok.service' found and move to '/lib/systemd/system/'"
    sudo mv ngrok.service /lib/systemd/system/
else
    sudo wget https://raw.githubusercontent.com/lamtota40/ngrok-easy-install/main/ngrok.service --no-check-certificate -P /lib/systemd/system/  
fi

wget $DOWNLOAD_URL --no-check-certificate
tar xvf $ARCHIVE
rm $ARCHIVE
sudo chmod +x ngrok

echo "Running ngrok v3 stable for ARCH $(uname -m) . . ."
systemctl enable ngrok.service
systemctl start ngrok.service
echo "Wait 10s…"
sleep 10
echo "Finish… to check status NGROK: http://127.0.01:4040"
echo "To setting configuration: ngrok.yml"
echo -e "To disable NGROK service on startup:\n systemctl disable ngrok.service"
echo -e "To stop service NGROK:\n systemctl stop ngrok.service"
echo -e "To change authtoken:\n /opt/dirngrok/ngrok config add-authtoken 2J8ncba…"

if [ ! $(which jq) ]; then
    echo -e "service online NGROK:\n"
    wget http://127.0.0.1:4040/api/tunnels -q -O -
else
    STATUSNGROK=$(wget http://127.0.0.1:4040/api/tunnels -q -O - | jq '.tunnels | .[] | "\(.name) \(.public_url)"')
    echo -e "service online NGROK:\n" $STATUSNGROK
fi
cd

#End script
