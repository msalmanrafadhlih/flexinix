# <p align="center"> <img src="https://i.imgur.com/X5zKxvp.png" width="200px"> </p>

<h1 align="center">Flexinix</h1>

<p align="center">
  <strong>A declarative, modular NixOS & Home Manager configuration factory.</strong>
</p>

<p align="center">
  <a href="https://nixos.org"><img src="https://img.shields.io/badge/NixOS-Stable/Unstable-blue?style=for-the-badge&logo=NixOS&logoColor=white&labelColor=303446" alt="NixOS"></a>
  <a href="https://github.com/nix-community/home-manager"><img src="https://img.shields.io/badge/Home--Manager-Enabled-green?style=for-the-badge&logo=nixos&logoColor=white&labelColor=303446" alt="Home Manager"></a>
  <a href="https://nixos.wiki/wiki/Flakes"><img src="https://img.shields.io/badge/Nix--Flakes-Enabled-9cf?style=for-the-badge&logo=nixos&logoColor=white&labelColor=303446" alt="Flakes"></a>
</p>

---

## 🖋️ Philosophy: The Intentional System

> "This is not merely a NixOS configuration. It is a declaration of how I choose to transform chaos into order — reproducible, intentional, and version-controlled."

Flexinix is built on the principle of **systemic reproducibility**. It treats infrastructure as a factory (`mkConfigs`) where systems are defined by their intent (stability, platform, and purpose) rather than manual imperative steps.

---

## 🌌 System Architecture

Flexinix uses a highly modular "Factory" approach. Instead of hardcoded configurations, it uses a custom library to generate system profiles based on stability levels (`stable` or `unstable`) and platform types.

### 🏗️ The `mkConfigs` Factory

Located in `.lib/mkConfigs.nix`, this factory handles the complexity of:

- **Stability Selection**: Easily switch between `nixos-stable` and `nixos-unstable` per host.
- **Platform Agnosticism**: Unified logic for NixOS, nix-darwin, Nix-on-Droid, and standalone Home Manager.
- **Auto-Mapping**: Maps hostnames to `hosts/${platform}-${hostname}/configuration.nix`.

### 📂 Directory Structure

```bash
.
├── hosts/                  # Host-specific hardware and overrides
├── homeModules/            # Global user-level Home Manager modules (Zsh, Tmux, Helix)
├── coreModules/            # Global system-level NixOS modules (Users, Locale, Services, specialisations)
├── flake.nix               # Entry point & Inputs
└── .lib/                   # Core logic, factory (mkConfigs), overlays & custom packages
     ├── packages           # custom packages built against nixpkgs
     ├── devShells
     ├── overlays           # overlays.default is the sum of all the overlays
     ├── legacyPackages.nix # applies overlays.default to nixpkgs.legacyPackages
     ├── mkConfigs.nix
     └── schemas.nix
```

---

## 🖥️ Target Hosts

| Name        | Hostname    | OS / Platform      | Stability | Role                |
| :---------- | :---------- | :----------------- | :-------- | :------------------ |
| **infinix** | `inbook-x1` | NixOS (x86_64)     | Unstable  | Primary Laptop      |
| **wsl**     | `wsl`       | NixOS-WSL (x86_64) | Stable    | Windows Development |
| **macbook** | `darwin`    | nix-darwin (ARM)   | Stable    | Workstation (macOS) |
| **android** | `And-1980`  | Nix-on-Droid (ARM) | Stable    | Mobile Environment  |

---

## 🚀 Key Features

### 🎨 Desktop & Specialisations

Flexinix supports **Specialisations**, allowing you to switch your entire desktop environment on the fly:

- **BSPWM**: Classic X11 tiling window manager.
- **Hyprland**: Modern Wayland compositor with eye-candy.
- **Niri**: Scrollable tiling Wayland compositor.
- Use `sudo nixos-rebuild --specialisation (bspwm|hyprland|niri)` to switch.

### 🛠️ Tooling & Integrations

- **Home Manager**: Deeply integrated for shell (Fish/Zsh), terminals (WezTerm), and editors (Helix).
- **Custom Library**: Includes custom packages like `desktopify-lite`, `process-manager`, and `bloodrage-plymouth`.
- **Overlays**: Global access to `pkgs.stable` and `pkgs.unstable` across all configurations.
- **External Configs**: Integrates external flakes like `racooonfig` for personal dotfiles.

---

## 🔧 Usage & Deployment

### Apply NixOS Configuration

```bash
# For Infinix (Laptop)
sudo nixos-rebuild switch --flake .#infinix

# For WSL
sudo nixos-rebuild switch --flake .#wsl
```

### Apply Home Manager (Standalone)

```bash
home-manager switch --flake .#infinix@tquilla
```

### Apply Darwin (macOS)

```bash
darwin-rebuild switch --flake .#macbook
```

### Apply Nix-on-Droid (Android)

```bash
nix-on-droid switch --flake .#default
```

---

## 🛠️ Built-in Modules & Overlays

This system leverages powerful community inputs:

- **NUR**: Nix User Repository integration.
- **Nix-WSL**: Seamless Linux integration on Windows.
- **Nix-Snapd**: Access to Snap packages on NixOS.
- **Devenv**: Reproducible development environments.
- **Sops-nix**: Secret management (SOPS).

---

## 🤝 Credits & Acknowledgements

Flexinix is a synthesis of various Nix community patterns. Special thanks to the contributors of Nixpkgs, Home Manager, and the creators of the various flakes integrated here.

<p align="center">
  <i>This system is configured. So is the life behind it.</i>
</p>
