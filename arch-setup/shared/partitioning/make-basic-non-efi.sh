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

pacstrap -K /mnt base grub

cp grub-non-efi.sh /mnt
arch-chroot /mnt sh ./grub-non-efi.sh




