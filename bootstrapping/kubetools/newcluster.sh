sudo sysctl net.bridge.bridge-nf-call-iptables=1

echo would you like to pull images? \(only do this if it is new hardware\) [y/N]
read SHOULD_PULL_IMAGES

if [[ $SHOULD_PULL_IMAGES == 'y' ]]; then
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
#sudo iptables -P FORWARD ACCEPT
