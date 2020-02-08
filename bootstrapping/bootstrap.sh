echo verifying user...
if [[ "${EUID}" != 0 ]] ; then
   echo "Must run as root."
   exit 1
fi

SCRIPT_DIR=$(basename "$0")
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

pacman-key --init
pacman-key --populate archlinuxarm
pacman -Syu

bash $SCRIPT_DIR/installs/utils.sh
