sudo sysctl net.bridge.bridge-nf-call-iptables=1

echo would you like to pull images? \(only do this if it is new hardware\) [y/N]
read SHOULD_PULL_IMAGES

if [[ $SHOULD_PULL_IMAGES == 'y' ]]; then
  echo pulling images...
  sudo kubeadm config images pull -v3
fi

echo what is the join command?
read JOIN_COMMAND
$(echo $JOIN_COMMAND)

#iptables -P FORWARD ACCEPT
