sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat ebtables libguestfs

sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service

# reboot!


