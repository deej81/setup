#!/bin/bash

pacman -Sy --noconfirm pacman-contrib

loadkeys uk

timedatectl set-timezone Europe/London

#partition disk vda for vm - non UEFI
parted /dev/vda --script -- mklabel gpt \
    mkpart primary 512MB -8GB \
    mkpart primary linux-swap -8GB 100%

mkfs.ext4 -L arch /dev/vda1
mkswap -L swap /dev/vda2

mount /dev/vda1 /mnt
swapon /dev/vda2

# generate mirror list for united kingdom
curl -s "https://archlinux.org/mirrorlist/?country=GB&protocol=https&ip_version=4" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - > /etc/pacman.d/mirrorlist

pacstrap -K /mnt base base-devel linux linux-firmware sof-firmware neovim git grub networkmanager wget

genfstab -U /mnt >> /mnt/etc/fstab

cp init.sh /mnt
arch-chroot /mnt sh ./init.sh

