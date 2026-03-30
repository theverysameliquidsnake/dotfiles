# dotfiles

My [Arch Linux](https://archlinux.org) setup

## Packages used

* Kernel:
  - [linux-zen](https://wiki.archlinux.org/title/Kernel)
* Bootloader:
  - [GRUB](https://wiki.archlinux.org/title/GRUB)
* File system:
  - [btrfs](https://wiki.archlinux.org/title/Btrfs)
* Shell:
  - [zsh](https://wiki.archlinux.org/title/Zsh)
  - [starship](https://starship.rs)
* Terminal:
  - [kitty](https://wiki.archlinux.org/title/Kitty)
* Bar:
  - [waybar](https://github.com/Alexays/Waybar)
* Display manager:
  - [ly](https://wiki.archlinux.org/title/Ly)
* Compositor / Window Manager:
  - [niri](https://wiki.archlinux.org/title/Niri) or [hyprland](https://wiki.archlinux.org/title/Hyprland)
* Launcher:
  - [wofi](https://hg.sr.ht/~scoopta/wofi)
* Notifications:
  - [mako](https://github.com/emersion/mako)
* File managers:
  - [lf](https://wiki.archlinux.org/title/Lf) and [thunar](https://wiki.archlinux.org/title/Thunar) for drag-and-drop
* Text editors:
  - [Neovim](https://wiki.archlinux.org/title/Neovim) + [LazyVim](https://www.lazyvim.org) or [VSCodium](https://wiki.archlinux.org/title/Visual_Studio_Code)
* Dev:
  - [go](https://wiki.archlinux.org/title/Go)
  - [node.js](https://wiki.archlinux.org/title/Node.js)
  - [npm](https://wiki.archlinux.org/title/Node.js)
  - [podman](https://wiki.archlinux.org/title/Podman)
* Browsers:
  - [Firefox](https://wiki.archlinux.org/title/Firefox)
  - [Brave](https://aur.archlinux.org/packages/brave-bin)
* Media:
  - [mpv](https://wiki.archlinux.org/title/Mpv)
  - [nicotine+](https://github.com/Nicotine-Plus/nicotine-plus)
* Games:
  - [Steam](https://wiki.archlinux.org/title/Steam)
* Messengers:
  - [telegram](https://wiki.archlinux.org/title/Telegram)
  - [vesktop](https://wiki.archlinux.org/title/Discord)
* Fonts:
  - [Fira Sans](https://wiki.archlinux.org/title/Fonts)
  - [FiraCode Nerd](https://wiki.archlinux.org/title/Fonts)
  - [Liberation](https://wiki.archlinux.org/title/Fonts)
  - [Noto Fonts Emoji](https://wiki.archlinux.org/title/Fonts)
  - [Noto Fonts CJK](https://wiki.archlinux.org/title/Fonts)
  - [KanjiStrokeOrders](https://www.nihilist.org.uk)
  - [Noto Fonts](https://wiki.archlinux.org/title/Fonts)
* Input:
  - [fcitx5](https://wiki.archlinux.org/title/Fcitx5)
  - [mozc](https://wiki.archlinux.org/title/Localization/Japanese)
* Blue filter:
  - [sunsetr](https://github.com/psi4j/sunsetr)
* AUR helper:
  - [yay](https://wiki.archlinux.org/title/AUR_helpers)
* Flatpak:
  - [flatpak](https://wiki.archlinux.org/title/Flatpak)
  - [flatseal](https://wiki.archlinux.org/title/Flatpak)
  - [Bottles](https://usebottles.com)
* Other:
  - [anki](https://wiki.archlinux.org/title/Anki)
  - [auto-cpufreq](https://github.com/AdnanHodzic/auto-cpufreq)
  - [btop](https://github.com/aristocratos/btop)
  - [intel graphics](https://wiki.archlinux.org/title/Intel_graphics)
  - [NetworkManager](https://wiki.archlinux.org/title/NetworkManager)
  - [qBittorrent](https://wiki.archlinux.org/title/QBittorrent)
  - [reflector](https://wiki.archlinux.org/title/Reflector)
  - [snapper](https://wiki.archlinux.org/title/Snapper)
  - [thermald](https://wiki.archlinux.org/title/CPU_frequency_scaling)
  - [ufw](https://wiki.archlinux.org/title/Uncomplicated_Firewall)
  - [yaak](https://github.com/mountain-loop/yaak)
  - [zram](https://wiki.archlinux.org/title/Zram)

## Installation

### Pre

```Zsh
# Set terminal layout
loadkeys us

# Verify boot mode (64)
cat /sys/firmware/efi/fw_platform_size

# Connect to the internet using cable or wi-fi with iwctl
iwctl

# Update clock
timedatectl list-timezones
timedatectl set-timezone <timezone>
timedatectl set-ntp true
timedatectl
```

### Disk

```Zsh
# Make sure disk in GPT mode
fdisk -l /dev/nvme0n1

# Create 2 partitions using cfdisk
# nvme0n1p1 / 512Mb / EFI System
# nvme0n1p2 / remaining space / Linux root x86-64
cfdisk /dev/nvme0n1

# Format partitions
mkfs.btrfs /dev/nvme0n1p2
mkfs.fat -F 32 /dev/nvme0n1p1

# Create subvolumes
mount /dev/nvme0n1p2 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
umount /mnt

# Mount partitions
mount -o noatime,ssd,compress=zstd,space_cache=v2,discard=async,subvol=@ /dev/nvme0n1p2 /mnt
mkdir /mnt/home
mount -o noatime,ssd,compress=zstd,space_cache=v2,discard=async,subvol=@home /dev/nvme0n1p2 /mnt/home
mkdir -p /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi
```

### Core

```Zsh
# Update mirrors
reflector -c <country> -a 12 --sort rate --save /etc/pacman.d/mirrorlist

# Core packages
pacstrap -K /mnt base linux-zen linux-zen-headers dkms linux-firmware sof-firmware intel-ucode neovim
```

### Fstab

```Zsh
# Generate fstab
genfstab -U -p /mnt >> /mnt/etc/fstab
```

### Chroot

```Zsh
# Chroot into system
arch-chroot /mnt
```

### Time

```Zsh
# Set local time zone
ln -sf /usr/share/zoneinfo/<Area>/<Location> /etc/localtime

# Sync clock
hwclock --systohc
```

### Lang

```Zsh
# Uncomment required locales
nvim /etc/locale.gen

# Generate locales
locale-gen

# Create and edit locale conf:
# LANG=en_US.UTF-8
# LC_TIME=en_GB.UTF-8
touch /etc/locale.conf
nvim /etc/locale.conf

# Set console layout
# KEYMAP=us
touch /etc/vconsole.conf
nvim /etc/vconsole.conf
```

### Hostname

```Zsh
# Create hostname
echo "<hostname>" >> /etc/hostname
```

### Multilib

```Zsh
# Uncomment in etc/pacman.conf:
# [multilib]
# Include = /etc/pacman.d/mirrorlist
nvim etc/pacman.conf

# Update system
pacman -Syu
```

### User

```Zsh
# Create root password
passwd

# Create user
useradd -m -g users -G wheel <username>
passwd <username>

# Add user to sudo group
pacman -S sudo
echo "<username> ALL=(ALL) ALL" >> /etc/sudoers.d/<username>
```

### Packages

```Zsh
# Shell
pacman -S zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions starship

# Network
pacman -S networkmanager reflector openssh

# Bluetooth
pacman -S bluez bluez-utils

# Audio
pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol

# Power
pacman -S acpi acpid thermald

# Power (optional and probably conflict if configured wrong)
# pacman -S tlp tlp-rdw

# Graphics
pacman -S mesa lib32-mesa vulcan-intel lib32-vulcan-intel intel-media-driver libva-utils

#Fonts
pacman -S ttf-fira-sans ttf-firacode-nerd ttf-liberation noto-fonts　noto-fonts-emoji noto-fonts-cjk

# Browser
pacman -S firefox

# File managers
pacman -S lf thunar

# Media
pacman -S mpv nicotine+

# Messenger
pacman -S telegram-desktop

# Dev
pacman -S go nodejs npm podman

# Games
pacman -S steam

# Man pages
pacman -S man-db man-pages texinfo

# Other
pacman -S brightnessctl btrfs-progs xdg-user-dirs fastfetch qbittorrent tor torsocks ffmpeg ffmpegthumbnailer btop wl-clipboard
```

### Mkinitcpio

```Zsh
# Edit /etc/mkinitcpio.conf:
# MODULES=(btrfs)
nvim /etc/mkinitcpio.conf

# Rebuid
mkinitcpio -P
```

### Bootloader

```Zsh
# Install grub
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

### Services

```Zsh
# Enable core services
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable acpid
systemctl enable thermald
systemctl enable reflector.timer
systemctl enable fstrim.timer
```

### Compositor

```Zsh
# Display manager
pacman -S ly
systemctl enable ly@tty1.service
systemctl disable getty@tty1.service

# Niri
pacman -S niri kitty mako wofi xdg-desktop-portal-gtk xdg-desktop-portal-gnome polkit-gnome waybar swaybg swayidle swaylock xwayland-satellite

# Hyprland
# pacman -S hyprland kitty mako wofi xdg-desktop-portal-hyprland hyprpolkitagent waybar hyprpaper qt5-wayland qt6-wayland
```

### Swap

```Zsh
# Install zram
pacman -S zram-generator

# Create config:
# [zram0]
# zram-size = 4096
# compression-algorithm = zstd
touch /etc/systemd/zram-generator.conf
nvim /etc/systemd/zram-generator.conf
```

### IMF/IME

```Zsh
# Install fcitx5 and mozc
pacman -S fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool fcitx5-mozc
```

### Exit chroot

```Zsh
# Exit from chroot
exit

# Unmount all
umount -R /mnt

# Reboot into main account
reboot

# Misc
sudo timedatectl set-ntp true

# Create standard folders
xdg-user-dirs-update

# Config yomitan and dictionaries
firefox
```

### Firewall

```Zsh
# Minimal firewall config
pacman -S ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo systemctl enable ufw
```

### Snapper

```Zsh
# Install cronie and snapper
sudo pacman -S snapper

# Create snapper config file for root volume
sudo snapper -c root create-config /

# Edit snapshot numbers:
# TIMELINE_MIN_AGE="1800"
# TIMELINE_LIMIT_HOURLY="5"
# TIMELINE_LIMIT_DAILY="7"
# TIMELINE_LIMIT_WEEKLY="0"
# TIMELINE_LIMIT_MONTHLY="0"
# TIMELINE_LIMIT_YEARLY="0"
sudo nvim /etc/snapper/configs/root

# Start services
sudo systemctl enable snapper-timeline.timer
sudo systemctl enable snapper-cleanup.timer
```

### Post

>Run from main account
```Zsh
# Install LazyVim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
nvim

# Check health
# :LazyHealth
nvim

# Change shell to zsh
sudo chsh -l /usr/bin/zsh
```

### AUR

>Run from main account
```Zsh
# Install yay
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Install packages from AUR
yay -S auto-cpufreq ttf-kanjistrokeorders pistol-git sunsetr yaak vscodium brave-bin vesktop

# Enable cpufreq
sudo systemctl enable auto-cpufreq
```

### Flatpak

>Run from main account
```Zsh
# Install flatpak and flatseal
sudo pacman -S flatpak flatseal

# Install bottles and fightcade
flatpak install flathub com.usebottles.bottles
flatpak install flathub com.fightcade.Fightcade
flatpak install flathub com.heroicgameslauncher.hgl
```
