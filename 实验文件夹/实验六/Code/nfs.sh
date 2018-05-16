#/bin/bash

sudo apt-get -y update
sudo apt-get -y install nfs-kernel-server

sudo mkdir -p /var/nfs/nfsstudy_public
sudo mkdir -p /var/nfs/nfsstudy_gernel
sudo mkdir -p /var/nfs/nfsstudy
sudo chown nobody:nogroup /var/nfs/nfsstudy_gernel

(sudo cat <<EOF
/var/nfs/nfsstudy_gernel 192.168.150.0/24(rw,insecure,sync,no_subtree_check)
/var/nfs/nfsstudy_public *(ro,insecure,sync,no_subtree_check)
/var/nfs/nfsstudy 192.168.150.3(rw,insecure,no_root_squash,sync,no_subtree_check)
EOF
)> /etc/exports

sudo exportfs -r
sudo /etc/init.d/nfs-kernel-server start
