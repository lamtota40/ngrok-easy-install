#!/usr/bin/env bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    echo "You can Try comand 'su root' or 'sudo -i'"
    exit 1
fi

lock1=/var/lib/dpkg/lock-frontend
lock2=/var/lib/dpkg/lock
lock3=/var/cache/apt/archives/lock

if [ -f "$lock1" ];then
if [ -z $(lsof -t $lock1) ]
then
      echo "Ok... file ($lock1) already delete"
else
      sudo kill -9 $(lsof -t $lock1)
      echo "Found..PID ($lock1) already kill & delete file"
fi
sudo rm -rf $lock1
fi
echo "wait 1"
sleep 10
##############################
if [ -f "$lock2" ];then
if [ -z $(lsof -t $lock2) ]
then
      echo "Ok... file ($lock2) already delete"
else
      sudo kill -9 $(lsof -t $lock2)
      echo "Found..PID ($lock2) already kill & delete file"
fi
sudo rm -rf $lock2
fi
echo "wait 2"
sleep 10
##############################
if [ -f "$lock3" ];then
if [ -z $(lsof -t $lock3) ]
then
      echo "Ok... file ($lock3) already delete"
else
      sudo kill -9 $(lsof -t $lock3)
      echo "Found..PID ($lock3) already kill & delete file"
fi
sudo rm -rf $lock3
fi
echo "wait 3"
sleep 10
sudo apt-get install --reinstall libappstream4
echo "wait 4"
sleep 10
sudo dpkg --configure -a
sudo apt-get update
echo "wait 5"
sleep 10
sudo apt-get install openssh-server -y

if [ ! $(which wget) ]; then
    sudo apt-get install wget -y
fi

if [ ! $(which jq) ]; then
    sudo apt-get install jq -y
fi
echo "wait 6"
sleep 10
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
echo "wait 7"
sleep 10
mkdir -p /opt/ngrok
cd /opt/ngrok
wget https://raw.githubusercontent.com/lamtota40/ngrok-easy-install/main/ngrok.yml
echo "wait 8"
sleep 10
sudo wget https://raw.githubusercontent.com/lamtota40/ngrok-easy-install/main/ngrok.service -P /lib/systemd/system/
#cp ngrok.service /lib/systemd/system/
echo "wait 9"
sleep 10
wget $DOWNLOAD_URL
echo "wait 10"
sleep 10
tar xvf $ARCHIVE
rm $ARCHIVE
sudo chmod +x ngrok

echo "Running ngrok for ARCH $(uname -m) . . ."
#./ngrok service install --config=ngrok.yml
systemctl enable ngrok.service
systemctl start ngrok.service
#./ngrok service start
echo "Wait 11…"
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
