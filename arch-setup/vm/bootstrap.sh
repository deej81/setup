#!/bin/bash

USERNAME=$1
HOSTNAME=$2

pacman -Sy --noconfirm pacman-contrib

loadkeys uk

timedatectl set-timezone Europe/London

#partition disk vda for vm - non UEFI
parted /dev/vda --script -- mklabel gpt \
    mkpart primary ext4 1MiB 500MiB \
    set 1 bios_grub on \
    mkpart primary linux-swap 500MiB 5GiB \
    mkpart primary ext4 5GiB 100%

mkfs.ext4 -L arch /dev/vda2
mkswap -L swap /dev/vda3

mount /dev/vda2 /mnt
swapon /dev/vda3

# generate mirror list for united kingdom
curl -s "https://archlinux.org/mirrorlist/?country=GB&protocol=https&ip_version=4" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - > /etc/pacman.d/mirrorlist

pacstrap -K /mnt base base-devel linux linux-firmware sof-firmware neovim git grub networkmanager wget zsh

genfstab -U /mnt >> /mnt/etc/fstab

cp init.sh /mnt
arch-chroot /mnt sh ./init.sh $USERNAME $HOSTNAME

