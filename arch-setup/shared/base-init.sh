#!/bin/bash

USERNAME=$1
HOSTNAME=$2

ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime

hwclock --systohc

sed -i 's/#en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen

locale-gen
echo "LANG=en_GB.UTF-8" >> /etc/locale.conf

echo "KEYMAP=uk" >> /etc/vconsole.conf

echo $HOSTNAME >> /etc/hostname

echo "ENTER ROOT PASSWORD"
passwd

useradd -m -G wheel -s /bin/bash $USERNAME
echo "ENTER $USERNAME PASSWORD"
passwd $USERNAME
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

systemctl enable NetworkManager

sudo -u $USERNAME git clone https://aur.archlinux.org/yay.git /home/$USERNAME/yay
cd /home/$USERNAME/yay
sudo -u $USERNAME makepkg -si --noconfirm

sudo -u $USERNAME git clone https://github.com/deej81/setup /home/$USERNAME/setup

echo "INSTALLATION COMPLETE. EXIT CHROOT AND REBOOT."