#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo verifying user...
if [[ "${EUID}" != 0 ]] ; then
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
until [[ -b $TARGET ]]; do
echo which device is your sd card? \(ie /dev/sda\)
  read TARGET
  if [[ ! -b "${TARGET}" ]] ; then
     echo "Not a block device: ${TARGET}"
  fi
done

if [[ $TARGET == "/dev/sda" ]]; then
  echo i don\'t think that is correct
  exit 1
fi

echo would you like to proceed wiping this device? [Y/n]
read DID_USER_CONFIRM
if [[ $DID_USER_CONFIRM == 'n' ]]; then
  echo exiting...
  exit 1
fi

echo wiping sd card and rewriting partitions..
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk $TARGET
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
  +300M # 100 MB boot parttion
  t # set partition type
  c # W95 FAT32 (LBA)
  n # partition 2
  p # primary partition
    # default start
    # default end
  w # write the changes
    # finish
EOF
echo finished partitioning $TARGET...
mkfs.vfat ${TARGET}p1
mkdir boot
mount ${TARGET}p1 boot
mkfs.ext4 ${TARGET}p2
mkdir root
mount ${TARGET}p2 root

# copy files
echo 'what architecture would you like to use?
[1] rpi 2/3 ARM 32 bit
[2] rpi 4 ARM 32bit
[3] rpi 3/4 ARM 64bit'
read RPI_MODEL_NUMBER

if [[ $RPI_MODEL_NUMBER == '1' ]]; then
  DOWNLOAD_LINK='http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz'
fi

if [[ $RPI_MODEL_NUMBER == '2' ]]; then
  DOWNLOAD_LINK='http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-4-latest.tar.gz'
fi

if [[ $RPI_MODEL_NUMBER == '3' ]]; then
  DOWNLOAD_LINK='http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-3-latest.tar.gz'
fi

echo do you have a local version of $DOWNLOAD_LINK [Y/n]?
read HAS_LOCAL_IMAGE
if [[ $HAS_LOCAL_IMAGE == 'n' ]]; then
  wget $DOWNLOAD_LINK
  LOCAL_IMAGE_PATH=$DOWNLOAD_LINK
fi

until [ -f "$LOCAL_IMAGE_PATH" ]; do
  echo what is the path to your image?
  read LOCAL_IMAGE_PATH
  if [! -f "$LOCAL_IMAGE_PATH" ]; then
    echo that is not a file..
  fi
done

bsdtar -xpvf $LOCAL_IMAGE_PATH -C root
sync
mv root/boot/* boot

echo copying bootstrap files...
cp -arv $SCRIPT_DIR/.. root/home/alarm

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

echo enabling dhcpcd...
ln -s /usr/lib/systemd/system/dhcpcd@.service root/etc/systemd/system/multi-user.target.wants/dhcpcd@wlan0.service
ln -s /usr/share/dhcpcd/hooks/10-wpa_supplicant root/usr/lib/dhcpcd/dhcpcd-hooks/

echo disabling dns security extensions...
echo 'DNSSEC=no' >> root/etc/systemd/resolved.conf

echo unmounting...
umount boot root
echo cleaning up...
rmdir boot root

echo you have successfully installed arch linux on this sd card and linked it to your wifi network!
echo the default root password is \'root\'
echo when you boot up your pi for the first time, don\'t forget to run:
echo \'su\'
echo \'bash /home/alarm/bootstrap.sh\'
