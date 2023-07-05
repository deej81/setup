#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime

hwclock --systohc

sed -i 's/#en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen

locale-gen
echo "LANG=en_GB.UTF-8" >> /etc/locale.conf

echo "KEYMAP=uk" >> /etc/vconsole.conf

echo "vm-1" >> /etc/hostname

echo "ENTER ROOT PASSWORD"
passwd

useradd -m -G wheel -s /bin/bash deej
echo "ENTER DEEJ PASSWORD"
passwd deej
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

systemctl enable NetworkManager

grub-install --target=i386-pc --recheck /dev/vda
grub-mkconfig -o /boot/grub/grub.cfg

echo "INSTALLATION COMPLETE. EXIT CHROOT AND REBOOT."





