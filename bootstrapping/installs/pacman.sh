SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo updating...
pacman-key --init
pacman-key --populate archlinuxarm
pacman -Syu
pacman -S archlinux-keyring

echo installing base utility programs...
pacman -S \
  binutils \
  cni-plugins \
  docker \
  docker-compose \
  ebtables \
  ethtool \
  fakeroot \
  k9s \
  gcc \
  git \
  go \
  make \
  neovim \
  ranger \
  socat \
  sudo \
  tmux
