cd /home/$USERNAME

echo installing yay...
sudo -u $USERNAME git clone https://aur.archlinux.org/yay.git
cd yay
sudo -u $USERNAME makepkg -si
cd ..
rm -rf yay

echo installing kubernetes...
#yay kubelet-bin
#yay kubectl-bin
#yay kubeadm-bin

sudo -u $USERNAME git clone https://aur.archlinux.org/kubelete-bin.git
cd kubelete-bin
sudo -u $USERNAME makepkg -si
cd ..
rm -rf kubelete-bin

sudo -u $USERNAME git clone https://aur.archlinux.org/kubectl-bin.git
cd kubectl-bin
sudo -u $USERNAME makepkg -si
cd ..
rm -rf kubectl-bin

sudo -u $USERNAME git clone https://aur.archlinux.org/kubeadm-bin.git
cd kubeadm-bin
sudo -u $USERNAME makepkg -si
cd ..
rm -rf kubeadm-bin
