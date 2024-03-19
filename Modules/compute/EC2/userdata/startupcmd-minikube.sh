#!/bin/bash
set -e 
# Ouput all log
exec > >(tee /var/log/user-data.log|logger -t user-data-extra -s 2>/dev/console) 2>&1

# Latest updates

apt update -y 

# Install Docker , make
apt install -y docker.io && apt install make

# Install the latest minikube stable release on x86-64 Linux using binary download
cd /root

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
chmod +x minikube-linux-amd64
mv minikube-linux-amd64 /usr/local/bin/minikube
cp /usr/local/bin/minikube /usr/bin

# Enable Users to Manage Environments

chown -R 777 /tmp

# Kubernetes latest requires conntrack

apt-get install -y conntrack
cd /usr/sbin/
chmod +x conntrack
ln -s /usr/sbin/conntrack /root/conntrack 

# install Go (1.21.0) 
cd /root
wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
sudo tar -xvf go1.21.0.linux-amd64.tar.gz
sudo mv go /usr/local
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
export GOCACHE=$HOME/go/cache
echo "export GOPATH=${GOPATH}" >> /root/.bashrc
echo "export PATH=${PATH}:/usr/local/go/bin:${GOPATH}/bin" >> /root/.bashrc
echo "export GOCACHE=$HOME/go/cache" >> /root/.bashrc
source ~/.bashrc

# cri-dockerd dependencie
git clone https://github.com/Mirantis/cri-dockerd.git /root/cri-dockerd
cd /root/cri-dockerd
source ~/.bashrc
go version
make cri-dockerd
mkdir -p /usr/local/bin
install -o root -g root -m 0755 cri-dockerd /usr/local/bin/cri-dockerd
install packaging/systemd/* /etc/systemd/system
sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
systemctl daemon-reload
systemctl enable --now cri-docker.socket

# Kubernetes 1.28.3 requires crictl to be installed in root’s path
cd /root
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.26.0/crictl-v1.26.0-linux-amd64.tar.gz
sudo tar zxvf crictl-v1.26.0-linux-amd64.tar.gz -C /usr/local/bin

# CNI Plugin

CNI_PLUGIN_VERSION="v1.3.0"
CNI_PLUGIN_TAR="cni-plugins-linux-amd64-$CNI_PLUGIN_VERSION.tgz" # change arch if not on amd64
CNI_PLUGIN_INSTALL_DIR="/opt/cni/bin"

curl -LO "https://github.com/containernetworking/plugins/releases/download/$CNI_PLUGIN_VERSION/$CNI_PLUGIN_TAR"
sudo mkdir -p "$CNI_PLUGIN_INSTALL_DIR"
sudo tar -xf "$CNI_PLUGIN_TAR" -C "$CNI_PLUGIN_INSTALL_DIR"
rm "$CNI_PLUGIN_TAR"


# Install Kubectl

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

# Make it executable

chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
chown -R 777 /tmp

# start minikube
cd /root
minikube start --vm-driver=none  --embed-certs






