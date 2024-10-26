#!/bin/bash

# instalação glusterfs
sudo dnf install glusterfs-server -y

# ativar e iniciar o serviço
sudo systemctl enable --now glusterd

# criar o diretorio onde o glusterfs vai ser montado
sudo mkdir -p /raid1/glusterfs