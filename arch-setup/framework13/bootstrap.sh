#!/bin/bash

pacman -Sy --noconfirm pacman-contrib

loadkeys uk

timedatectl set-timezone Europe/London

# run parted unattended
parted /dev/nvme0n1 --script -- mklabel gpt \
    mkpart primary 512MB -8GB \
    mkpart primary linux-swap -8GB 100% \
    mkpart ESP fat32 1MB 512MB \
    set 3 esp on

mkfs.ext4 -L arch /dev/nvme0n1p1
mkswap -L swap /dev/nvme0n1p2
mkfs.fat -F 32 -n boot /dev/nvme0n1p3

mount /dev/nvme0n1p1 /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p3 /mnt/boot
swapon /dev/nvme0n1p2

# generate mirror list for united kingdom
curl -s "https://archlinux.org/mirrorlist/?country=GB&protocol=https&ip_version=4" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - > /etc/pacman.d/mirrorlist

pacstrap -K /mnt base base-devel linux linux-firmware sof-firmware neovim git grub efibootmgr networkmanager wget

genfstab -U /mnt >> /mnt/etc/fstab

cp init.sh /mnt
arch-chroot /mnt sh ./init.sh

