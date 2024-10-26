#!/bin/bash

/vagrant/mount-glusterfs.sh

sudo dnf install mariadb-server pacemaker corosync pcs -y

sudo cp /vagrant/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# https://mariadb.com/kb/en/mariadb-install-db/#options
# https://mariadb.com/kb/en/configuring-mariadb-with-option-files/
if [ "$(ls -A /cluster/sql)" ]; then
    sleep 5
else
    sudo mkdir -p /cluster/sql
    sudo mariadb-install-db --defaults-file=/etc/mysql/my.cnf
    sudo chmod -R 777 /cluster/sql

sudo cp /vagrant/corosync-sql.conf /etc/corosync/corosync.conf
sudo systemctl enable --now corosync pacemaker pcsd

sudo pcs resource create mariadb systemd:mariadb op monitor interval=1s

sudo pcs property set stonith-enabled=false

sudo pcs resource create virtualip ocf:heartbeat:IPaddr2 ip=192.168.32.110 cidr_netmask=24 op monitor interval=1s

sudo pcs constraint colocation add mariadb with virtualip INFINITY

sudo pcs resource update mariadb meta migration-threshold=0
sudo pcs resource update virtualip meta migration-threshold=0

sudo systemctl restart corosync pacemaker pcsd