#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime

hwclock --systohc

sed -i 's/#en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen

locale-gen
echo "LANG=en_GB.UTF-8" >> /etc/locale.conf

echo "KEYMAP=uk" >> /etc/vconsole.conf

echo "framework13" >> /etc/hostname

passwd

