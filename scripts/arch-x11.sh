#!/bin/sh

# Configure pacman
doas sed -i "/UseSyslog/,/Color/"'s/^#//' /etc/pacman.conf
doas sed -i "/VerbosePkgLists/,/ParallelDownloads/"'s/^#//' /etc/pacman.conf
doas sed -i "/ParallelDownloads/"'a ILoveCandy' /etc/pacman.conf
doas sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

# Prerequisites
doas pacman -S stow git rustup autoconf automake binutils bison debugedit fakeroot file findutils flex gawk gcc gettext grep groff gzip libtool m4 make patch pkgconf texinfo which unzip nodejs npm unrar p7zip --noconfirm

# Dotfiles
git clone https://github.com/BenTowali/dotfiles.git
cd dotfiles
stow . -t /home/$(whoami)/

# Download Zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

# Paru
## Install
doas ln -s $(which doas) /usr/bin/sudo
rustup default stable
git clone https://aur.archlinux.org/paru.git
cd paru && makepkg -si
cd .. && rm -rf paru
## Configure
doas sed -i "/AurOnly/"'s/^#//' /etc/paru.conf
doas sed -i "/RemoveMake/"'s/^#//' /etc/paru.conf
doas sed -i "/CleanAfter/,/UpgradeMenu/"'s/^#//' /etc/paru.conf
doas sed -i "/NewsOnUpgrade/"'a BatchInstall' /etc/paru.conf
doas sed -i "/BatchInstall/"'a SkipReview' /etc/paru.conf
doas sed -i "/[bin]/"'s/^#//' /etc/paru.conf
doas sed -i "/Sudo = doas/"'s/^#//'

# Wine
doas pacman -S wine-staging winetricks wine-nine wine-gecko wine-mono --noconfirm

# Other Stuff
doas pacman -S ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-noto-nerd noto-fonts-emoji noto-fonts-cjk noto-fonts noto-fonts-extra qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat ebtables iptables libguestfs trash-cli xorg lazygit gamemode sx glow feh xclip neofetch openssh ssh-tools pipewire pipewire-pulse fcitx fcitx-configtool fcitx-im pulsemixer playerctl dunst syncthing zathura zathura-pdf-poppler scrcpy rofi redshift picom mpv discord keepassxc obsidian sxiv nitrogen lf steam awesome polybar alacritty --noconfirm

# AUR
paru -S anki-bin an-anime-game-launcher-bin xdg-ninja spotify raindrop librewolf-bin --noconfirm

# After Config
## Libvirt
doas systemctl enable libvirtd.service --now
doas sed -i "/unix_sock_group/"'s/^#//' /etc/libvirt/libvirtd.conf
doas sed -i "/unix_rw_perms/"'s/^#//' /etc/libvirt/libvirtd.conf
doas usermod -aG audio,kvm,libvirt $(whoami)
doas systemctl restart libvirtd.service
## Other
doas sysctl -w vm.max_map_count=2147483642