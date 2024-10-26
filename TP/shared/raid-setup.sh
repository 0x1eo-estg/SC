#!/bin/bash

# instalar mdadm
sudo dnf install mdadm 

# criação do RAID 1
sudo mdadm --create /dev/md0 --level=1 --raid-devices /dev/sdb /dev/sdc -R

# criar//montar filesystem
sudo mkfs.ext4 /dev/md0
sudo mkdir /raid1
sudo mount /dev/md0 /raid1
echo '/dev/md127 /raid1 exrt default 0 0' | sudo tee -a /etc/fstab