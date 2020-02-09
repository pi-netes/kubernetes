SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo verifying user...
if [[ "${EUID}" != 0 ]] ; then
   echo "Must run as root."
   exit 1
fi

if [[ ! -f "/home/alarm/bootstrap.sh" ]]; then # not currently booted into pi
  echo this is only intended to be used in conjunction with the arclinux.sh install script! would you like to install archlinux on an sd card now? [Y/n]
  read SHOULD_INSTALL_ARCH_LINUX
  if [[ $SHOULD_INSTALL_ARCH_LINUX == 'n' ]]; then
    echo "nothing to do!"
    exit 0
  else
    bash $SCRIPT_DIR/installs/archlinux.sh
    exit 0
  fi
fi

echo what would you like to name this machine?
read HOSTNAME
hostnamectl set-hostname $HOSTNAME

echo setting global options...
sed -i 's/\#Color/Color\nILoveCandy\nTotalDownload/g' /etc/pacman.conf

echo installing utilities...
bash $SCRIPT_DIR/installs/utils.sh

echo installing user profile...
echo what would you like to name your user?
read USERNAME
export $USERNAME
bash $SCRIPT_DIR/installs/userprofile.sh

echo installing docker and docker compose...
pacman -S docker docker-compose
systemctl start docker
systemctl enable docker

echo installing kubernetes and kubeadm...
sudo -u $USERNAME yay kubernetes-bin
sudo -u $USERNAME yay kubeadm-bin

echo installing k9s...
pacman -S k9s

echo configuring cluster...
sudo -u $USERNAME /home/$USERNAME/kubetools/kubetools.sh

echo cleaning up...
rm -rf /home/alarm
userdel alarm
