<p align="center">
  <img src="https://i.imgur.com/X5zKxvp.png" width="200px">
</p>

<h1 align="center">.dotfiles</h1>

<p align="center">
  <strong>A declarative life management system built with NixOS & Home Manager</strong>
</p>

<p align="center">
  <a href="https://nixos.org"><img src="https://img.shields.io/badge/NixOS-Unstable-blue?style=for-the-badge&logo=NixOS&logoColor=white&labelColor=303446" alt="NixOS Unstable"></a>
  <a href="https://github.com/nix-community/home-manager"><img src="https://img.shields.io/badge/Home--Manager-Enabled-green?style=for-the-badge&logo=nixos&logoColor=white&labelColor=303446" alt="Home Manager"></a>
  <a href="https://nixos.wiki/wiki/Flakes"><img src="https://img.shields.io/badge/Nix--Flakes-Enabled-9cf?style=for-the-badge&logo=nixos&logoColor=white&labelColor=303446" alt="Flakes"></a>
</p>

---

## 🖋️ Philosophy: The Intentional System

> "This is not merely a NixOS configuration. It is a declaration of how I choose to transform chaos into order — reproducible, intentional, and version-controlled."

Life management is essential. Like an operating system, it should not run randomly or without structure—it must be declared. NixOS teaches that the best systems are built upon clear, conscious, and reproducible configurations. 

Just as NixOS provides generations and rollback capabilities, life itself should allow room for evaluation and refinement without sacrificing stability. We do not erase the past; we preserve it as a reference to build improved versions of ourselves.

---

## 🌌 System Architecture

This repository manages multiple environments using a modular Flake-based approach. It separates system-level concerns from user-level applications and development workflows.

### 🖥️ Target Hosts
| Hostname | Platform | Role | Architecture |
| :--- | :--- | :--- | :--- |
| **infinix** | NixOS | Primary Laptop (Inbook X1) | `x86_64-linux` |
| **macbook** | nix-darwin | Workstation (macOS) | `aarch64-darwin` |
| **wsl** | NixOS-WSL | Development on Windows | `x86_64-linux` |
| **vm-aarch64** | NixOS | Virtual Machines (Parallels/UTM) | `aarch64-linux` |

### 📂 Directory Structure
```bash
.
├── flake.nix             # Main entry point
├── lib/                  # Custom library functions (mksystem.nix)
├── nixos/                # Host-specific hardware/system configs
├── modules/              # Shared NixOS/Darwin system modules
└── development/          # Sub-flake for Home Manager & User configs
    ├── configs/          # Raw application dotfiles (Alacritty, BSPWM, etc.)
    ├── modules/          # User-level Nix modules & Custom Scripts
    └── users/            # User-specific profiles (bspwm, niri, hyprland)
```

---

## 🚀 Key Features

### 🎨 Desktop Environments
*   **BSPWM**: A tiling window manager that represents my core workflow.
*   **Hyprland/Niri**: Modern Wayland-based alternatives for fluid experiences.
*   **Stylix**: Unified system-wide theming for consistent aesthetics.

### 🛠️ Development & Tooling
*   **Terminals**: Alacritty, Kitty, Ghostty, and a custom `st-flexipatch`.
*   **Editors**: VS Code, Zed Editor, and Geany.
*   **Shell**: Zsh managed via Home Manager with Starship prompt.
*   **Browsers**: Firefox, Zen Browser, Vivaldi, and Chromium.

### 📜 Custom Automation
Managed under `development/modules/scripts/`, these scripts power my daily productivity:
*   `01chat`: Integrated LLM/Chat interactions.
*   `img-compress`: Automated image optimization.
*   `github-repos`: Repository management and automation.
*   `battery` / `brightness` / `volume`: Hardware control utilities.

---

## 🔧 Installation & Deployment

### Prerequisites
*   Nix with Flakes enabled.
*   Git for cloning the repository.

### Initial Setup
```bash
# Clone the repository
git clone https://github.com/msalmanrafadhlih/Dotfiles.git ~/.dotfiles

# Apply NixOS configuration (replace <hostname> with infinix, wsl, or vm)
sudo nixos-rebuild switch --flake .#<hostname>

# Apply Darwin configuration (macOS)
darwin-rebuild switch --flake .#macbook
```

### Local Development
The `development/` directory is a standalone sub-flake. You can test user-level changes without rebuilding the whole system:
```bash
cd development
home-manager switch --flake .#bspwm
```

---

## 🛠️ Built-in Modules & Overlays
This system leverages powerful community inputs:
*   **Nix-WSL**: Seamless Linux integration on Windows.
*   **Nix-Snapd**: Access to Snap packages on NixOS.
*   **Spicetify-nix**: Fully customized Spotify experience.
*   **Bloodrage-Plymouth**: Custom boot animations.

---

## 🤝 Credits & Acknowledgements
This configuration is a result of standing on the shoulders of giants in the Nix community. Special thanks to the contributors of Nixpkgs, Home Manager, and the various flakes integrated into this system.

<p align="center">
  <i>This system is configured. So is the life behind it.</i>
</p>
