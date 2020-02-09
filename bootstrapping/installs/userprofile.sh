SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
useradd -d /home/$USERNAME -m -G wheel -s /bin/bash $USERNAME
passwd $USERNAME

echo adding user $USERNAME to sudoers file...
echo '%sudo ALL=(ALL:ALL) ALL' >> /etc/sudoers
groupadd sudo
usermod -a -G sudo $USERNAME

echo installing yay...
cd /home/$USERNAME
sudo -u $USERNAME git clone https://aur.archlinux.org/yay.git
cd yay
sudo -u $USERNAME makepkg -si
cd ..
rm -rf yay

echo provisioning dotfiles...
mkdir /home/$USERNAME/.config
mv $SCRIPT_DIR/../configs/.* /home/$USERNAME/
mv $SCRIPT_DIR/../kubetools /home/$USERNAME/
rmdir $SCRIPT_DIR/../configs
chown -R $USERNAME:users /home/$USERNAME

export $USERNAME
