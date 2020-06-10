#!/bin/bash
if [ ! -b /dev/nvme0n2 ]; then
     exit 1
else
   if [ ! -e /root/diskdone ]; then
      pvcreate /dev/nvme0n2
      vgcreate vg02 /dev/nvme0n2
      lvcreate -n LVdata -l 100%free vg02 -y
      mkfs.xfs -f /dev/mapper/vg02-LVdata
      mkdir -pv /data/
      echo "/dev/mapper/vg02-LVdata  /data/   xfs   defaults 0 0"  >> /etc/fstab
      mount -a >/dev/null 2>&1
      touch /root/diskdone
   fi
fi

if [ ! -e /root/nfsdone ]; then 
   yum install rpcbind nfs-utils telnet net-tools bind-utils gcc -y >/dev/null 2>&1
   if [ $? -ne 0 ]; then
      echo "yum Eroor exit process ..."
      exit 1
   fi
   touch /root/nfsdone
fi

status=$(systemctl list-unit-files | grep firewalld | awk '{print $2}')

if [ "status" == "enabled" ];then
   systemctl stop firewalld 
   systemctl disable firewalld 
fi

if [ ! -e /root/ntpdone ]; then
   echo "/data/ *(rw,sync,no_root_squash)" > /etc/exports
   systemctl enable rpcbind.service
   systemctl enable nfs-server.service 
   systemctl restart rpcbind.service
   systemctl restart nfs-server.service
   
   if [ $? -eq 0 ]; then
      touch /root/ntpdone
   fi 
fi
