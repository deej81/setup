
pacman -Sy --noconfirm pacman-contrib

loadkeys uk

timedatectl set-timezone Europe/London

# generate mirror list for united kingdom
curl -s "https://archlinux.org/mirrorlist/?country=GB&protocol=https&ip_version=4" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - > /etc/pacman.d/mirrorlist

pacstrap -K /mnt base base-devel linux linux-firmware sof-firmware neovim git grub networkmanager wget openssh

genfstab -U /mnt >> /mnt/etc/fstab

cp base-init.sh /mnt
arch-chroot /mnt sh ./base-init.sh $USERNAME $HOSTNAME