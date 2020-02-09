echo disabling swap...
sudo dphys-swapfile swapoff && sudo dphys-swapfile uninstall && sudo update-rc.d dphys-swapfile remove
sudo systemctl disable dphys-swapfile

echo Adding " cgroup_enable=cpuset cgroup_enable=memory" to /boot/cmdline.txt...
sudo cp /boot/cmdline.txt /boot/cmdline_backup.txt
orig="$(head -n1 /boot/cmdline.txt) cgroup_enable=cpuset cgroup_enable=memory"
echo $orig | sudo tee /boot/cmdline.txt

echo fixing docker driver...
echo '{
	"exec-opts": ["native.cgroupdriver=systemd"],
	"log-driver": "json-file",
	"log-opts": {
    "max-size": "100m"
	},
	"storage-driver": "overlay2"
}' > /etc/docker/daemon.json

echo adding container networking plugins to weave path...
mkdir -p /opt/cni/bin
ln -s /usr/lib/cni/* /opt/cni/bin

echo enabling docker and kubelet..
systemctl daemon-reload
systemctl start docker
systemctl enable docker
systemctl enable kubelet
