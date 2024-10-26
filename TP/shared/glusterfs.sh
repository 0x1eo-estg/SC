#!/bin/bash

STORAGE_DIR=/raid1/glusterfs
VOLUME_NAME=storage

SERVER1=192.168.32.121
SERVER2=192.168.32.122
SERVER3=192.168.32.111
SERVER4=192.168.32.112

# https://docs.gluster.org/en/latest/Install-Guide/Configure/
sudo gluster peer probe $SERVER1
sudo gluster peer probe $SERVER2
sudo gluster peer probe $SERVER3
sudo gluster peer probe $SERVER4

sudo gluster volume create $VOLUME_NAME replica 2 $SERVER1:$STORAGE_DIR $SERVER2:$STORAGE_DIR $SERVER3:$STORAGE_DIR $SERVER4:$STORAGE_DIR force
sudo gluster volume start $VOLUME_NAME