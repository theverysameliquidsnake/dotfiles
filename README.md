# dotfiles (WIP)

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
* Terminal:
  - [kitty](https://wiki.archlinux.org/title/Kitty)
* Display manager:
  - [ly](https://wiki.archlinux.org/title/Ly)
* Window manager:
  - [hyprland](https://wiki.archlinux.org/title/Hyprland)
* Launcher:
  - [wofi](https://hg.sr.ht/~scoopta/wofi)
* Notifications:
  - [mako](https://github.com/emersion/mako)
* File managers:
  - [lf](https://wiki.archlinux.org/title/Lf)
  - [thunar](https://wiki.archlinux.org/title/Thunar)
* Text editors:
  - [Neovim](https://wiki.archlinux.org/title/Neovim)
  - [VS Code](https://wiki.archlinux.org/title/Visual_Studio_Code)
* Browsers:
  - [Firefox](https://wiki.archlinux.org/title/Firefox)
  - [Brave](https://aur.archlinux.org/packages/brave-bin)
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
  - [Bottles](https://usebottles.com/)
  - [Fightcade](https://www.fightcade.com)
* Other:
  - [anki](https://wiki.archlinux.org/title/Anki)
  - [btop](https://github.com/aristocratos/btop)
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
pacstrap -K /mnt base linux-zen linux-zen-headers dkms linux-firmware intel-ucode neovim
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
```

### Hostname

```Zsh
# Create hostname
echo "<hostname>" >> /etc/hostname
```

### User

```Zsh
# Create root password
passwd

# Create user
useradd -m -g users -G wheel <username>
passwd <username>

# Add user to sudo group
echo "<username> ALL=(ALL) ALL" >> /etc/sudoers.d/<username>
```

### Packages

```Zsh
# Network
pacman -S networkmanager reflector openssh

# Bluetooth
pacman -S bluez bluez-utils

# Audio
pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber

# Man pages
pacman -S man-db man-pages texinfo

# Other
pacman -S sudo git btrfs-progs base-devel acpi
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

### Firewall

```Zsh
# Minimal firewall config
pacman -S ufw
ufw default deny incoming
ufw default allow outgoing
ufw enable
systemctl enable ufw
```

### Services

```Zsh
# Enable core services
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable acpid
systemctl enable reflector.timer
systemctl enable fstrim.timer
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

### Snapper

```Zsh
# Install cronie and snapper
pacman -S cronie snapper

# Create snapper config file for root volume
snapper -c root create-config /

# Edit snapshot numbers:
# TIMELINE_MIN_AGE="1800"
# TIMELINE_LIMIT_HOURLY="5"
# TIMELINE_LIMIT_DAILY="7"
# TIMELINE_LIMIT_WEEKLY="0"
# TIMELINE_LIMIT_MONTHLY="0"
# TIMELINE_LIMIT_YEARLY="0"
nvim /etc/snapper/configs/root

# Start cron service
systemctl enable cronie.service
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
yay -S ttf-kanjistrokeorders sunsetr yaak visual-studio-code-bin brave-bin
```

### Flatpak

>Run from main account
```Zsh
# Install flatpak and flatseal
sudo pacman -S flatpak flatseal

# Install bottles and fightcade
flatpak install flathub com.usebottles.bottles
flatpak install flathub com.fightcade.Fightcade
```
