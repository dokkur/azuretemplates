#!/bin/sh
pvcreate /dev/sd[cdefg]
vgcreate vol_data /dev/sd[cdefg]
lvcreate --extents 100%FREE --stripes 5 --stripesize 256 --name root vol_data
mkfs.xfs /dev/mapper/vol_data-root
mkdir /data
mount /dev/mapper/vol_data-root /data/
chmod 777 -R /data

echo /dev/mapper/vol_data-root /data xfs defaults 0 0 >> /etc/fstab

yum -y install nfs-utils
systemctl enable nfs-server.service
systemctl start nfs-server.service

# $1 is a network prefix for given machine
echo "/data/ ${1}(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
exportfs -a
