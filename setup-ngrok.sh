sudo apt install wget unzip -y
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip
wget https://raw.githubusercontent.com/lamtota40/tes/main/ngrok.yml
unzip ngrok-v3-stable-linux-amd64.zip
chmod +x ngrok
./ngrok service install --config=ngrok.yml
