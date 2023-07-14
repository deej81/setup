
grub-install /dev/nvme0n1 --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg
