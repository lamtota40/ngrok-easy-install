# ngrok-easy-install
Easy instalation for Ngrok v3 stable

Function Ngrok: for tunnel if not have ip public
aplication for SSH,RDP,VNC,Website,other

# instalation
register on https://dashboard.ngrok.com/signup
https://dashboard.ngrok.com/get-started/your-authtoken
```console
wget -qO- n9.cl/sngrok | bash
```
if use git clone
```console
apt-get install git -y
```
```console
mkdir -p /opt/dirngrok
```
```console
git clone https://github.com/lamtota40/ngrok-easy-install.git /opt/dirngrok
```
```console
bash /opt/dirngrok/setup-ngrok.sh
```

# Documentation
<img src="https://user-images.githubusercontent.com/26719371/215472523-183ef332-3c92-491d-bac3-ae0b66a5c130.jpg" width="150">

- Limitation NGROK for free user
+ 1 online ngrok process (it should not expire)
+ 4 tunnels / ngrok process
+ 40 connections / minute
+ every disconected change new url

# For alternative NGROK
https://www.softwaretestinghelp.com/ngrok-alternatives/
https://burrow.io/
