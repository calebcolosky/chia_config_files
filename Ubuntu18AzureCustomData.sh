#!/bin/bash
#This is the custom data script for Ubuntu 18.04

#Install pre-requisite software
sudo apt-get update
sudo apt-get upgrade -y
sudo apt install git -y
sudo apt-get install python3.7-venv python3.7-distutils python3.7-dev git lsb-release -y

#Format and mount drives
mkdir /mnt/ssd
mkdir /mnt/plots
mkdir /opt/chia-logs
mkfs -t ext4 /dev/sdc
mkfs -t ext4 /dev/sdd
mount /dev/sdc /mnt/ssd
mount /dev/sdd /mnt/plots


#Install Chia
git clone https://github.com/Chia-Network/chia-blockchain.git -b latest --recurse-submodules /opt/chia-blockchain
cd /opt/chia-blockchain
sh install.sh
. ./activate

#Install and configure Swar-Chia-Plot-Manager
git clone https://github.com/swar/Swar-Chia-Plot-Manager.git /opt/Swar-Chia-Plot-Manager
git clone https://github.com/calebcolosky/chia_config_files.git /opt/chia_config_files
cp /opt/chia_config_files/config.yaml /opt/Swar-Chia-Plot-Manager/config.yaml
#Change keys here when necessary
sed -i 's/REPLACE_FARMERKEY/b6a5afce3a1c9fa37a80c77872f9a7dce86877b8bf04433bfe955de67d7a120c7ca947348de98b5365cefef14125d141/g' /opt/Swar-Chia-Plot-Manager/config.yaml
sed -i 's/REPLACE_POOLKEY/81a01f6818eb90cd26fb08929536d43f8b7ea200ac49c073f8c27ec00dfc2bd7786bfce22f7226c9a888654021a695c2/g' /opt/Swar-Chia-Plot-Manager/config.yaml
python -m venv venv
. ./venv/bin/activate
chia init
pip install -r /opt/Swar-Chia-Plot-Manager/requirements.txt
chia start node
cd /opt/Swar-Chia-Plot-Manager
python manager.py start



#OUTDATED: Plotting without Swar-Chia-Plot-Manager
#------------------------------------------------------------------
echo "#!/bin/bash
screen -d -m -S chia1 bash -c 'cd /opt/chia-blockchain && . ./activate && chia plots create -f 81a01f6818eb90cd26fb08929536d43f8b7ea200ac49c073f8c27ec00dfc2bd7786bfce22f7226c9a888654021a695c2 -p b6a5afce3a1c9fa37a80c77872f9a7dce86877b8bf04433bfe955de67d7a120c7ca947348de98b5365cefef14125d141 -k 32 -b 4000 -e -r 6 -u 128 -n 2 -t /mnt/ssd/temp1 -2 /mnt/ssd -d /mnt/plots | tee /home/ec2-user/chia1.log'
screen -d -m -S chia1 bash -c 'cd /opt/chia-blockchain && sleep 2h && . ./activate && chia plots create -f 81a01f6818eb90cd26fb08929536d43f8b7ea200ac49c073f8c27ec00dfc2bd7786bfce22f7226c9a888654021a695c2 -p b6a5afce3a1c9fa37a80c77872f9a7dce86877b8bf04433bfe955de67d7a120c7ca947348de98b5365cefef14125d141 -k 32 -b 4000 -e -r 6 -u 128 -n 2 -t /mnt/ssd/temp1 -2 /mnt/ssd -d /mnt/plots | tee /home/ec2-user/chia1.log'
screen -d -m -S chia1 bash -c 'cd /opt/chia-blockchain && sleep 2h && . ./activate && chia plots create -f 81a01f6818eb90cd26fb08929536d43f8b7ea200ac49c073f8c27ec00dfc2bd7786bfce22f7226c9a888654021a695c2 -p b6a5afce3a1c9fa37a80c77872f9a7dce86877b8bf04433bfe955de67d7a120c7ca947348de98b5365cefef14125d141 -k 32 -b 4000 -e -r 6 -u 128 -n 2 -t /mnt/ssd/temp1 -2 /mnt/ssd -d /mnt/plots | tee /home/ec2-user/chia1.log'
screen -d -m -S chia1 bash -c 'cd /opt/chia-blockchain && sleep 2h && . ./activate && chia plots create -f 81a01f6818eb90cd26fb08929536d43f8b7ea200ac49c073f8c27ec00dfc2bd7786bfce22f7226c9a888654021a695c2 -p b6a5afce3a1c9fa37a80c77872f9a7dce86877b8bf04433bfe955de67d7a120c7ca947348de98b5365cefef14125d141 -k 32 -b 4000 -e -r 6 -u 128 -n 2 -t /mnt/ssd/temp1 -2 /mnt/ssd -d /mnt/plots | tee /home/ec2-user/chia1.log'" > /opt/chia_manual_plotting.sh
chmod 755 /opt/chia_manual_plotting.sh


