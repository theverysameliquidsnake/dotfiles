# dotfiles

My [Arch Linux](https://archlinux.org) setup

## Packages used

* Kernel:
  - [linux-zen](https://wiki.archlinux.org/title/Kernel)
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
  - [anki](https://github.com/ankitects/anki)
  - [btop](https://github.com/aristocratos/btop)
  - [yaak](https://github.com/mountain-loop/yaak)

## Installation

### Snapper

```
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

```
# Install yay
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Install packages from AUR
yay -S ttf-kanjistrokeorders sunsetr anki yaak visual-studio-code-bin brave-bin
```

### Flatpak

>Run from main account
```
# Install flatpak and flatseal
sudo pacman -S flatpak flatseal

# Install bottles and fightcade
flatpak install flathub com.usebottles.bottles
flatpak install flathub com.fightcade.Fightcade
```
