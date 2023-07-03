SHELL := /bin/bash

install-requirements:
	python3 -m venv .venv
	source .venv/bin/activate
	python3 -m pip install -r requirements.txt

	# install yq
	sudo pacman -S yq --noconfirm

install-hyprland-dev:
	python3 install_profile.py hyprland-dev

update: gitpull install-hyprland-dev

gitpull:
	git pull

