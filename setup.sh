#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

echo is this new hardware? yes/no
read varname
if [[ $varname == "yes" ]]; then

echo would you like to install dependencies? yes/no
read varname
if [[ $varname == "yes" ]]; then
    echo installing dependencies
    sudo apt -y install dkms apt-transport-https ca-certificates curl gnupg2 software-properties-common
fi

echo was there a failed previous docker install? yes/no
read varname
if [[ $varname == "yes" ]]; then
echo purging old docker install...
sudo apt-get purge docker
sudo apt-get purge docker.io
sudo apt-get purge docker-compose
fi

echo would you like to install docker? yes/no
read varname
if [[ $varname == "yes" ]]; then
echo installing docker...
echo 'deb [arch=armhf] https://download.docker.com/linux/debian buster stable' >> /etc/apt/sources.list
sudo apt-get update
curl -sL get.docker.com | sed 's/9)/10)/' | sh
echo fixing docker driver
echo '{
	"exec-opts": ["native.cgroupdriver=systemd"],
	"log-driver": "json-file",
	"log-opts": {
		"max-size": "100m"
	},
	"storage-driver": "overlay2"
}' > /etc/docker/daemon.json
fi

echo disabling swap...
sudo dphys-swapfile swapoff && sudo dphys-swapfile uninstall && sudo update-rc.d dphys-swapfile remove 
sudo systemctl disable dphys-swapfile  

echo Adding " cgroup_enable=cpuset cgroup_enable=memory" to /boot/cmdline.txt...
sudo cp /boot/cmdline.txt /boot/cmdline_backup.txt
orig="$(head -n1 /boot/cmdline.txt) cgroup_enable=cpuset cgroup_enable=memory"                                                                             
echo $orig | sudo tee /boot/cmdline.txt

echo installing kube...
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && sudo apt-get update
sudo apt-get install -y kubeadm
fi


echo is this the master node? yes/no
read varname
if [[ $varname == "yes" ]]; then
echo initializing master node

echo is this the first cluster created on this hardware? yes/no
read varname
if [[ $varname == "no" ]]; then
echo removing last cluster...
sudo kubeadm reset
sudo rm -rf /var/lib/etcd # if not first time creating cluster
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
fi

if [[ $varname == "yes" ]]; then
echo pulling images...
sudo kubeadm config images pull -v3
fi

echo assuming weave network controller...
sudo kubeadm init && # --pod-network-cidr=10.244.0.0/16 # flannel only
echo generating configs...
mkdir -p $HOME/.kube &&
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config &&
sudo chown $(id -u):$(id -g) $HOME/.kube/config &&

#make sure your vpn isn't conflicting with ip's!
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')" &&
sudo sysctl net.bridge.bridge-nf-call-iptables=1

echo Would you like to congigure the webhook listener at this time? yes/no
read varname
if [[ $varname == "yes" ]]; then
echo setting up webhook listener...
cp -r ./python-webhook-listener ~/

echo setting up automatic deployment pipeline
token=$(openssl rand -base64 32 | tr -d "=+/")
echo "[Unit]
Description=webhook listener to pull latest docker images
After=network.target

[Service]
Environment=DOCKER_TOKEN=$token
ExecStart=/usr/bin/python3 app.py
WorkingDirectory=/home/pi/python-webhook-listener
StandardOutput=inherit
StandardError=inherit
Restart=always
User=pi

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/docker-autodeploy.service
systemctl start docker-autodeploy
systemctl enable docker-autodeploy
fi

echo setting up packet forwarding between nodes...
echo '#wait a bit after reboot and then configure everything
sleep 90
iptables -P FORWARD ACCEPT' > /home/pi/configure.sh

echo setting up master node vpn...
echo 'iptables -I INPUT -p tcp -s 10.8.0.0/16 --dport 8000 -j ACCEPT
iptables -I INPUT -p udp -s 10.8.0.0/16 --dport 53 -j ACCEPT
sleep 90
systemctl start openvpn' >> /home/pi/configure.sh
chmod +x /home/pi/configure.sh

echo setting up autostart on reboot...
echo '#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.
bash /home/pi/configure.sh &

# Print the IP address
_IP=$(hostname -I) || true
if [ "$_IP" ]; then
  printf "My IP address is %s\n" "$_IP"
fi

exit 0' > /etc/rc.local

echo cleaning up...
sudo bash /home/pi/configure.sh &
fi

echo is this a worker node? yes/no
read varname
if [[ $varname == "yes" ]]; then
echo configuring worker node

echo is this the first cluster created on this hardware? yes/no
read varname
if [[ $varname == "no" ]]; then
echo removing last cluster...
sudo kubeadm reset
sudo rm -rf /var/lib/etcd # if not first time creating cluster
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
fi


echo what is the join command?
read joincommand
$(echo $joincommand)

#echo what is the ip address of the master node?
#read masterip
#echo what is the join token?
#read jointoken
#echo what is the cert hash?
#read certhash
#sudo kubeadm join $masterip:6443 --token $jointoken --discovery-token-ca-cert-hash certhash
sudo sysctl net.bridge.bridge-nf-call-iptables=1

echo setting up packet forwarding between nodes...
echo '#wait a bit after reboot and then configure everything
sleep 90
iptables -P FORWARD ACCEPT' > /home/pi/configure.sh

chmod +x /home/pi/configure.sh

echo setting up autostart on reboot...
echo '#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.
bash /home/pi/configure.sh &

# Print the IP address
_IP=$(hostname -I) || true
if [ "$_IP" ]; then
  printf "My IP address is %s\n" "$_IP"
fi

exit 0' > /etc/rc.local

echo cleaning up...
sudo bash /home/pi/configure.sh &
fi

###############################################
#echo preparing the dashboard
#kubectl apply -f kubernetes-dashboard.yaml 
#kubectl apply -f dashboard-admin.yaml 

#echo getting login token
#kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
###############################################
