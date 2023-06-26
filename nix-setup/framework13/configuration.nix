# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  	nixpkgs.config.allowUnfree = true;
  	nixpkgs.config.permittedInsecurePackages = [
        "openssl-1.1.1u"
		"python-2.7.18.6"
    ];
	hardware.opengl.driSupport32Bit = true;
	hardware.pulseaudio.support32Bit = true;

  	imports =
    	[ # Include the results of the hardware scan.
      		./hardware-configuration.nix
    	];
	boot.kernelParams = [ "i915.force_probe=46a6" ];

	# Use the systemd-boot EFI boot loader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	# Hyprland configuration
	# programs.hyprland.enable = true;


	networking.hostName = "nixos"; # Define your hostname.
	# Pick only one of the below networking options.
	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
	networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

	# Set your time zone.
	time.timeZone = "Europe/London";

  	# Select internationalisation properties.
	i18n.defaultLocale = "en_GB.UTF-8";
	
	console = {
    		packages=[ pkgs.terminus_font ];
    		font="${pkgs.terminus_font}/share/consolefonts/ter-i22b.psf.gz";
    		useXkbConfig = true; # use xkbOptions in tty.
  	};

	# Enable the X11 windowing system.
  	services.xserver.enable = true;
  	services.xserver.windowManager.dwm.enable = true;
  	services.xserver.layout = "us";

  	services.xserver.displayManager = {
		lightdm.enable = true;
  		autoLogin = {
			enable = true;
			user = "titus";
		};
	};
  
 	services.picom.enable = true;
  	# Enable sound.
  	sound.enable = true;
  	hardware.pulseaudio.enable = true;


  	# Define a user account. Don't forget to set a password with ‘passwd’.
  	users.users.deej = {
   		isNormalUser = true;
   		extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
   		packages = with pkgs; [
      			neovim
     			firefox
  		];
 	};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
		vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
		neovim
		wget
		w3m
		dmenu
		neofetch
		autojump
		starship
		brave
		bspwm
		cargo
		celluloid
		chatterino2
		clang-tools_9
		davinci-resolve
		dwm
		dunst
		elinks
		eww
		feh
		flameshot
		flatpak
		fontconfig
		freetype
		gcc
		gh
		gimp
		git
		gnugrep
		gnumake
		gparted
		hugo
		kitty
		#libverto
		luarocks
		lutris
		mangohud
		neovim
		nfs-utils
		ninja
		nodejs
		nomacs
		openssl
		pavucontrol
		picom
		polkit_gnome
		powershell
		protonup-ng
		python3Full
		python.pkgs.pip
		qemu
		ripgrep
		rofi
		sxhkd
		st
		stdenv
		synergy
		#swaycons
		terminus-nerdfont
		tldr
		trash-cli
		unzip
		variety
		virt-manager
		xclip
		xdg-desktop-portal-gtk
		xfce.thunar
		xorg.libX11
		xorg.libX11.dev
		xorg.libxcb
		xorg.libXft
		xorg.libXinerama
		xorg.xinit
  ];

	nixpkgs.overlays = [
		(final: prev: {
			dwm = prev.dwm.overrideAttrs (old: { src = /home/deej/github/dwm-deej ;});
		})
  	];
	

	
	# List services that you want to enable:
	# virtualisation.libvirtd.enable = true; 
	# enable flatpak support
  	services.flatpak.enable = true;
  	services.dbus.enable = true;
  	xdg.portal = {
    	enable = true;
    	# wlr.enable = true;
    	# gtk portal needed to make gtk apps happy
    	extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  	};

  	security.polkit.enable = true;
 	
	systemd = {
  		user.services.polkit-gnome-authentication-agent-1 = {
    		description = "polkit-gnome-authentication-agent-1";
    		wantedBy = [ "graphical-session.target" ];
    		wants = [ "graphical-session.target" ];
    		after = [ "graphical-session.target" ];
    		serviceConfig = {
        		Type = "simple";
        		ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        		Restart = "on-failure";
        		RestartSec = 1;
        		TimeoutStopSec = 10;
      		};
  		};
   	extraConfig = ''
     	DefaultTimeoutStopSec=10s
   	'';
	}; 

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	networking.firewall.enable = false;
	networking.enableIPv6 = false;

	# Enable the OpenSSH daemon.
 	services.openssh.enable = true;

	fonts = {
    	fonts = with pkgs; [
			noto-fonts
			noto-fonts-cjk
			noto-fonts-emoji
			font-awesome
			source-han-sans
			source-han-sans-japanese
			source-han-serif-japanese
			(nerdfonts.override { fonts = [ "Meslo" ]; })
    	];
    	fontconfig = {
      		enable = true;
			defaultFonts = {
				monospace = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
				serif = [ "Noto Serif" "Source Han Serif" ];
				sansSerif = [ "Noto Sans" "Source Han Sans" ];
			};
    	};
	};

	# Copy the NixOS configuration file and link it from the resulting system
	# (/run/current-system/configuration.nix). This is useful in case you
	# accidentally delete configuration.nix.
	system.copySystemConfiguration = true;
	system.autoUpgrade.enable = true;  
	system.autoUpgrade.allowReboot = true; 
	system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.05";
	
	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# TEST (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "22.11"; # Did you read the comment
}


