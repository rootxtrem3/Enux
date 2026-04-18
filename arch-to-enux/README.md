# Arch To Enux

This subfolder turns an existing Arch Linux install into the current Enux desktop and branding layer without pulling the ISO builder parts of the repo.

What it does:

- installs the packages required by the current Enux Hyprland UI
- installs `yay` if it is missing
- applies the Enux dotfiles to the current user and `/etc/skel`
- writes EnuxOS branding files such as `/usr/lib/os-release`
- adds an `EnuxOS` Hyprland session entry for display managers

What it does not do:

- rebuild the system into a separate distro
- touch the ISO build pipeline
- replace your package manager or pacman configuration

Run it from this repo:

```bash
cd arch-to-enux
./setup-enux.sh
```

The installer prefers the local `dotfiles/` directory in this subfolder. If that folder is not present, it can sparse-checkout only `arch-to-enux/dotfiles` from `https://github.com/rootxtrem3/Enux`.

Backups of replaced user config files are stored under `~/.local/state/enux-backups/`.
