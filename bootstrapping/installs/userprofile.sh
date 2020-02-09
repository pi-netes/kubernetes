SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
useradd -m -G wheel -s /bin/bash $USERNAME
passwd $USERNAME

echo adding user $USERNAME to sudoers file...
echo '%sudo ALL=(ALL:ALL) ALL' >> /etc/sudoers
groupadd sudo
usermod -a -G sudo $USERNAME

echo provisioning dotfiles...
mv $SCRIPT_DIR/../configs/.* /home/$USERNAME/
mv $SCRIPT_DIR/../kubetools /home/$USERNAME/
rmdir $SCRIPT_DIR/../configs
chown -R $USERNAME:users /home/$USERNAME
