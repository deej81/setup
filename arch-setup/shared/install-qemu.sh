sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat libguestfs

sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service

# reboot!

# it can be very grumpy running the networking unless you reboot after an update

# run this if network is not working
# sudo virsh net-start default

# if you want to run windows - firstly why? secondly watch this https://www.youtube.com/watch?v=6KqqNsnkDlQ


