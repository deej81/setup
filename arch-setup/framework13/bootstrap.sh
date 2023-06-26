#!/bin/bash

loadkeys uk

timedatectl set-timezone Europe/London

parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart primary 512MB -8GB
parted /dev/nvme0n1 -- mkpart primary linux-swap -8GB 100%

parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB
parted /dev/nvme0n1 -- set 3 esp on

mkfs.ext4 -L arch /dev/nvme0n1p1
mkswap -L swap /dev/nvme0n1p2
mkfs.fat -F 32 -n boot /dev/nvme0n1p3

mount /dev/nvme0n1p1 /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p3 /mnt/boot
swapon /dev/nvme0n1p2

pacstrap -K /mnt base base-devel linux linux-firmware sof-firmware neovim git grub efibootmgr networkmanager wget

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt ./init.sh

