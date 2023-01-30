#!/usr/bin/env bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    echo "You can Try comand 'su root' or 'sudo -i'"
    exit 1
fi

#ps -A | grep apt
#ps aux | grep apt
#pkill regexp
#pkill -f regexp
#kill -9
lock1=/var/lib/apt/lists/lock
lock2=/var/lib/dpkg/lock-frontend
lock3=/var/lib/dpkg/lock
lock4=/var/cache/apt/archives/lock

if [ -f "$lock1" ];then
if [ -z $(lsof -t $lock1) ]
then
      echo "Ok... file ($lock1) already delete"
else
      sudo kill -9 $(lsof -t $lock1)
      echo "Found..PID ($lock1) already kill & delete file"
fi
sudo rm $lock1
fi
##############################
if [ -f "$lock2" ];then
if [ -z $(lsof -t $lock2) ]
then
      echo "Ok... file ($lock2) already delete"
else
      sudo kill -9 $(lsof -t $lock2)
      echo "Found..PID ($lock2) already kill & delete file"
fi
sudo rm $lock2
fi
##############################
if [ -f "$lock3" ];then
if [ -z $(lsof -t $lock3) ]
then
      echo "Ok... file ($lock3) already delete"
else
      sudo kill -9 $(lsof -t $lock3)
      echo "Found..PID ($lock3) already kill & delete file"
fi
sudo rm $lock3
fi
##############################
if [ -f "$lock4" ];then
if [ -z $(lsof -t $lock4) ]
then
      echo "Ok... file ($lock4) already delete"
else
      sudo kill -9 $(lsof -t $lock4)
      echo "Found..PID ($lock4) already kill & delete file"
fi
sudo rm $lock4
fi

sudo dpkg --configure -a
sudo apt-get install --reinstall libappstream4
sudo apt-get install -f
sudo apt-get update

sudo apt-get install openssh-server -y

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

mkdir -p /opt/ngrok
cd /opt/ngrok
wget https://raw.githubusercontent.com/lamtota40/ngrok-easy-install/main/ngrok.yml
sudo wget https://raw.githubusercontent.com/lamtota40/ngrok-easy-install/main/ngrok.service -P /lib/systemd/system/
wget $DOWNLOAD_URL
tar xvf $ARCHIVE
rm $ARCHIVE
sudo chmod +x ngrok

echo "Running ngrok for ARCH $(uname -m) . . ."
#./ngrok service install --config=ngrok.yml
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
