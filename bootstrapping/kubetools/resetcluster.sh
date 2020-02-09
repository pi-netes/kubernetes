echo removing last cluster...
sudo kubeadm reset
sudo rm -rf /var/lib/etcd # if not first time creating cluster
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
