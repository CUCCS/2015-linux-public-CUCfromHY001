#!/bin/bash



echo -n -e '\033[36mPlease enter userName(CUCfromHY default): \033[0m'
read userName
if [ ! -n "$userName" ];then
        echo "userName will be set to CUCfromHY"
        userName=CUCfromHY
else
        echo "userName will be set to $userName"
fi


echo -n -e '\033[36mPlease enter PASSWORD(123456 default): \033[0m'
read password
if [ ! -n "$password" ];then
        echo "password will be set to 123456"
        password=123456
else
        echo "password will be set to $password"
fi


ftp_dir="$HOME/ftp"

writable="Share Files"



if [ "x$(id -u)" != x0 ]; then 
  echo "Error: please run this script with 'sudo'." 
  exit 1
fi


sudo apt-get -y install vsftpd

sudo apt-get -y install db-util


cd /tmp
printf "$userName\n$password\n" > vusers.txt
db_load -T -t hash -f vusers.txt vsftpd-virtual-user.db
sudo cp -f vsftpd-virtual-user.db /etc/
cd /etc
chmod 600 vsftpd-virtual-user.db
if [ ! -e vsftpd.conf.old ]; then
 sudo cp -f vsftpd.conf vsftpd.conf.old
fi


(sudo cat <<EOF
auth       required     pam_userdb.so db=/etc/vsftpd-virtual-user
account    required     pam_userdb.so db=/etc/vsftpd-virtual-user
session    required     pam_loginuid.so
EOF
) > pam.d/vsftpd.virtual


owner=`who am i| awk '{print $1}'`


(sudo cat <<EOF
listen=YES
anonymous_enable=NO
local_enable=YES
virtual_use_local_privs=YES
write_enable=YES
local_umask=000
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
chroot_local_user=YES
hide_ids=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd.virtual
guest_enable=YES
user_sub_token=$USER
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
EOF
) > vsftpd.conf
sudo echo "local_root=$ftp_dir" >> vsftpd.conf

sudo echo "guest_username=$owner" >> vsftpd.conf



mkdir "$ftp_dir"
mkdir "$ftp_dir/$writable"
sudo chmod a-w "$ftp_dir"
sudo chown -R $owner:$owner $ftp_dir

sudo /etc/init.d/vsftpd restart