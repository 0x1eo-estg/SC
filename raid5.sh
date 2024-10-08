# Criação RAID-5
# Instalação mdadm
# sudo apt-get install mdadm

# Criação de blocos virtuais
sudo dd if=/dev/zero of=/mnt/disk1.img bs=1M count=512
sudo dd if=/dev/zero of=/mnt/disk2.img bs=1M count=512
sudo dd if=/dev/zero of=/mnt/disk3.img bs=1M count=512
sudo dd if=/dev/zero of=/mnt/disk4.img bs=1M count=512
sudo dd if=/dev/zero of=/mnt/disk5.img bs=1M count=512

# Mapear para loopback
sudo losetup /dev/loop0 /mnt/disk1.img
sudo losetup /dev/loop1 /mnt/disk2.img
sudo losetup /dev/loop2 /mnt/disk3.img
sudo losetup /dev/loop3 /mnt/disk4.img
sudo losetup /dev/loop4 /mnt/disk5.img

# Criação do array
sudo mdadm --create /dev/md0 --level=5 --raid-devices=4 --spare-devices=1 /dev/loop[0-3] /dev/loop4

# Verificar status
cat /proc/mdstat

# Criar sistema // montar
sudo mkfs.ext4 /dev/md0
sudo mkdir /storage
sudo mount /dev/md0 /storage

# Verificação
df -h

# Falha de disco
# Simulação de falha
sudo mdadm --manage /dev/md0 --fail /dev/loop0
cat /proc/mdstat

# Remover disco
sudo mdadm --manage /dev/md0 --remove /dev/loop0

# Adicionar disco (loop original)
sudo mdadm --manage /dev/md0 --add /dev/loop0
cat /proc/mdstat

# Teste de RW
# Leitura
sudo hdparm -tT /dev/md0

# Escrita
sudo dd if=/dev/zero of=/storage/testfile bs=1M count=1024 oflag=direct
sudo dd if=/storage/testfile of=/dev/null bs=1M count=1024
