#!/usr/bin/env bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    echo "You can Try comand 'su - root' or 'sudo -i'"
    exit 1
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

sudo apt-get install jq -y
mkdir -p /opt/ngrok
cd /opt/ngrok
wget https://raw.githubusercontent.com/lamtota40/ngrok-easy-install/main/ngrok.yml
wget https://raw.githubusercontent.com/lamtota40/ngrok-easy-install/main/ngrok.service
wget $DOWNLOAD_URL
tar xvf $ARCHIVE
rm $ARCHIVE
sudo chmod +x ngrok
clear
echo "Running ngrok for $(uname -m) . . ."
#./ngrok service install --config=ngrok.yml
sleep 3
systemctl enable ngrok.service
systemctl start ngrok.service
#./ngrok service start
echo "Wait 10s…"
sleep 10
echo -e "Finish… to check status NGROK: \n http://127.0.01:4040"
echo "First enter comand 'cd /opt/ngrok'"
echo -e "To stop service NGROK:\n systemctl stop ngrok.service"
echo -e "To setting configuration:\n sudo nano ngrok.yml"
echo -e "To change authtoken:\n ./ngrok config add-authtoken 2J8ncba…"

if [ ! $(which jq) ]; then
    echo -e "service online NGROK:\n"
    wget http://127.0.0.1:4040/api/tunnels -q -O -
else
    STATUSNGROK=$(wget http://127.0.0.1:4040/api/tunnels -q -O - | jq '.tunnels | .[] | "\(.name) \(.public_url)"')
    echo -e "service online NGROK:\n" $STATUSNGROK
fi
cd

#End script
