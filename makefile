SHELL := /bin/bash

install-requirements:
	python3 -m venv .venv
	source .venv/bin/activate
	python3 -m pip install -r requirements.txt

	# install yq
	sudo pacman -S yq --noconfirm

update-dotfiles:
	cd dotfiles && stow */ -v --target=/home/deej --adopt

update: gitpull update-dotfiles

gitpull:
	git pull

bootstrap-vm:
	cd arch-setup/vm && sh bootstrap.sh $(USERNAME) $(HOSTNAME)

USERNAME ?= $(shell bash -c 'read -p "Enter Username: " username; echo $$username')
HOSTNAME ?= $(shell bash -c 'read -p "Enter Hostname: " hostname; echo $$hostname')

