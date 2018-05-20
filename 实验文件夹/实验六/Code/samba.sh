#!/bin/sh
sudo apt-get update
sudo apt-get -y install samba samba-common
service iptables stop
sudo mkdir /home/share
sudo chmod 777 /home/share
sudo useradd smbuse
sudo smbpasswd -a smbuser
sudo service smbd restart