#!/bin/bash
echo verifying user...
if [[ "${USER}" != "root" ]] ; then
   echo "Must run as root."
   exit 1
fi

echo verifying install location...
[ -d "boot" ] && { echo must create a tmp boot directory, please do not run this in /; exit 1; }
[ -d "root" ] && { echo must create a tmp root directory, please do not run this in /; exit 1; }

echo verifying dependencies...
type wget >/dev/null  2>&1 || { echo please install wget; exit 1; }
type bsdtar >/dev/null  2>&1 || { echo please install bsdtar; exit 1; }
type wpa_passphrase >/dev/null  2>&1 || { echo please install wpa_passphrase; exit 1; }

echo preparing to write to sd card...
rmmod mmc_block
rmmod sdhci-pci
rmmod sdhci
modprobe mmc_block
modprobe sdhci debug_quirks=0x40 debug_quirks2=0x4
modprobe sdhci-pci
sleep 8 # must wait for mods to load

echo partitioning device...
lsblk
until [[ -b $target ]]; do
echo which device is your sd card? \(ie /dev/sda\)
  read target
  if [[ ! -b "${target}" ]] ; then
     echo "Not a block device: ${target}"
  fi
done

echo would you like to proceed wiping this device? [Y/n]
read didUserConfirm
if [[ $didUserConfirm == 'n' ]]; then
  echo exiting...
  exit 1
fi

if [[ $target == "/dev/sda" ]]; then
  echo i don\'t think that is correct
  exit 1
fi

echo wiping sd card and rewriting partitions..
sleep 1
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk $target
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
  +100M # 100 MB boot parttion
  t # set partition type
  c # W95 FAT32 (LBA)
  n # partition 2
  p # primary partition
    # default start
    # default end
  w # write the changes
    # finish
EOF
echo finished partitioning $target...
mkfs.vfat ${target}p1
mkdir boot
mount ${target}p1 boot
mkfs.ext4 ${target}p2
mkdir root
mount ${target}p2 root

# copy files
echo 'what model pi do you have?
[1] rpi 2 or 3
[2] rpi 4'
read rpiModelNumber

if [[ $rpiModelNumber == '1' ]]; then # has rpi 2 or 3
  echo do you have a local version of ArchLinuxARM-rpi-2-latest.tar.gz [Y/n]?
  read hasLocalImage
  if [[ $hasLocalImage == 'n' ]]; then
    wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
    bsdtar -xpvf ArchLinuxARM-rpi-latest.tar.gz -C root
  else
    until [ -f "$imagePath" ]; do
      echo what is the path to your image?
      read imagePath
      if [ -f "$imagePath" ]; then
        bsdtar -xpvf $imagePath -C root
      else
        echo that is not a file..
      fi
    done
  fi
fi

if [[ $rpiModelNumber == '2' ]]; then # has rpi 4
  echo do you have a local version of ArchLinuxARM-rpi-4-latest.tar.gz [Y/n]?
  read hasLocalImage
  if [[ $hasLocalImage == 'n' ]]; then
    wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-4-latest.tar.gz
    bsdtar -xpvf ArchLinuxARM-rpi-latest.tar.gz -C root
  else
    until [ -f "$imagePath" ]; do
      echo what is the path to your image?
      read imagePath
      if [ -f "$imagePath" ]; then
        bsdtar -xpvf $imagePath -C root
      else
        echo that is not a valid file..
      fi
    done
  fi
fi
sync
mv root/boot/* boot

echo configuring boot...
echo "hdmi_force_hotplug=1" >> boot/config.txt
echo "hdmi_drive=2" >> boot/config.txt
echo "hdmi_safe=1" >> boot/config.txt
echo "boot_delay=1" >> boot/config.txt


echo setting up wifi...
echo what is your network ssid?
read SSID
echo what is your network password?
read PASS

cat << EOF > root/etc/wpa_supplicant/wpa_supplicant-wlan0.conf
ctrl_interface=DIR=/var/run/wpa_supplicant
update_config=1

network={
        ssid="$SSID"
        psk="$PASS"
}
EOF
ln -s /usr/lib/systemd/system/dhcpcd@.service root/etc/systemd/system/multi-user.target.wants/dhcpcd@wlan0.service
ln -s /usr/share/dhcpcd/hooks/10-wpa_supplicant root/usr/lib/dhcpcd/dhcpcd-hooks/

echo unmounting...
umount boot root
echo cleaning up...
rmdir boot root

echo you have successfully installed arch linux on this sd card and linked it to your wifi network!
sleep 1
echo your default user will be alarm with password alarm - please change this
sleep 1
echo when you boot up your pi for the first time, don\'t forget to run these commands:
sleep 1
echo pacman-key --init
echo pacman-key --populate archlinuxarm