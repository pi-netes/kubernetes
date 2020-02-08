SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo installing base utility programs...
sleep 1
pacman -S \
  binutils \
  fakeroot \
  gcc \
  git \
  go \
  make \
  neovim \
  ranger \
  sudo

#TODO: set up user creation here
echo adding user alarm to sudoers file...
echo '%sudo ALL=(ALL:ALL) ALL' >> /etc/sudoers
groupadd sudo
usermod -a -G sudo alarm

echo installing yay...
sleep 1
sudo -u alarm git clone https://aur.archlinux.org/yay.git
cd yay
sudo -u alarm makepkg -si
cd ..
rm -rf yay

echo provisioning dotfiles...
sleep 1
mkdir /home/alarm/.config
mv $SCRIPT_DIR/../configs/.* /home/alarm/
rmdir $SCRIPT_DIR/../configs
chown -R alarm:users /home/alarm

echo resetting passord...
passwd alarm
