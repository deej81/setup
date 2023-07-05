#!/bin/bash

pacman -Sy --noconfirm pacman-contrib

loadkeys uk

timedatectl set-timezone Europe/London

#partition disk vda for vm - non UEFI
parted /dev/vda --script -- mklabel gpt \
    mkpart primary ext3 1MiB 100MiB \
    set 1 boot on \
    mkpart primary linux-swap 100MiB 4GiB \
    mkpart primary ext4 4GiB 100%

mkfs.ext4 -L arch /dev/vda2
mkswap -L swap /dev/vda3


mount /dev/vda2 /mnt
swapon /dev/vda3

mkdir /mnt/boot
mount /dev/vda1 /mnt/boot

# generate mirror list for united kingdom
curl -s "https://archlinux.org/mirrorlist/?country=GB&protocol=https&ip_version=4" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - > /etc/pacman.d/mirrorlist

pacstrap -K /mnt base base-devel linux linux-firmware sof-firmware neovim git grub networkmanager wget

genfstab -U /mnt >> /mnt/etc/fstab

cp init.sh /mnt
arch-chroot /mnt sh ./init.sh

