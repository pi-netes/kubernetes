SCRIPT_DIR=$(basename "$0")
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
  sudo

#echo '%sudo ALL=(ALL:ALL) ALL' >> /etc/sudoers
#groupadd sudo
#usermod -a -G sudo alarm
echo installing yay...
sleep 1
su - alarm
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay
su

echo provisioning dotfiles...
sleep 1
mkdir /home/root/.config
mkdir /home/alarm/.config
mv $SCRIPT_DIR/../configs/nvim /home/root/config
mv $SCRIPT_DIR/../.bashrc /home/root
mv $SCRIPT_DIR/../.bash_aliases /home/root
mv $SCRIPT_DIR/../.tmux.conf /home/root
ln -s /home/root/.config /home/alarm/.config
ln -s /home/root/.bashrc /home/alarm/.bashrc
ln -s /home/root/.bash_aliases /home/alarm/.bash_aliases
ln -s /home/root/.tmux.conf /home/alarm/.tmux.conf
