# ./modules/programs.nix
# programs & system packages
{ isWSL}:
{ pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  nixpkgs.config.allowUnfree = true;

  programs = {
    git.enable = true;

  } // (if isLinux then {
    # firefox.enable = true;
    thunderbird.enable = true;
    # # to use gamemode with steam edit launch options inside
    # # game -> general -> launch options -> `gamemoderun %command%`
    # steam.enable = true;
    gamemode.enable = true;
  } else {});


  environment.systemPackages = with pkgs; [

    # ======= CLI TOOLS (portable)
    gh            # GitHub CLI
    ripgrep       # Fast recursive grep
    git-lfs       # Git Large File Storage
    bat           # Better cat with syntax highlighting
    yazi          # Modern terminal file manager
    dust          # Disk usage analyzer
    fd            # Fast alternative to find
    file          # Detect file type
    fzf           # Fuzzy finder for terminal
    procs         # Modern replacement for ps
    sd            # Intuitive sed replacement
    tokei         # Code statistics by language
    yt-dlp        # Advanced YouTube/video downloader
    btop          # Resource monitor
    tree          # Directory tree viewer
    tmux          # Terminal multiplexer
    atuin      # smart command shell histories

    # ======= UTILITIES
    nixpkgs-fmt   # Nix formatter

    # ======= NETWORKING (portable)
    curl          # Transfer data via URL
    dnsutils      # DNS tools (dig, nslookup)
    miniserve     # Simple static file HTTP server
    nmap          # Network scanner
    rsync         # File synchronization tool
    wget          # Non-interactive file downloader

    # ======= REMOTE ACCESS
    freerdp       # RDP client for remote desktop

    # ======= LANGUAGE / COMPILER
    luajit        # High-performance Lua implementation
    python3       # Python interpreter

    # ======= LSP
    nixd          # Nix language server
    # python313Packages.python-lsp-server # (or ty/ruff) python
    # typescript-language-server # javascript, typescript..
    # jdt-language-server # Java
    # vscode-json-languageserver # json
    # vscode-css-languageserver # css
    # superhtml # html
    # rust-analyzer # Rust
    # marksman # .md/markdown
    # taplo # toml
    # yaml-language-server # yaml

  ] ++ (lib.optionals isDarwin [

    # ======= macOS ONLY
    cachix        # Nix binary cache client
    gettext       # GNU gettext utilities (often missing on macOS)

  ]) ++ (lib.optionals (!isWSL) [

    # ======= Linux & wsl
    jujutsu # Smart Git

  ]) ++ (lib.optionals (isLinux && !isWSL) [

    # ======= LINUX ONLY
    acpi          # Show battery / ACPI power information
    psmisc        # Process utilities (killall, pstree)
    inetutils     # Networking utilities (telnet, ftp, etc)
    iputils       # Network utilities (ping, arping)

    # ======= ARCHIVESkkkkkk
    gnutar        # GNU tar archiver
    p7zip         # 7z compression utility
    unzip         # Extract .zip archives
    xz            # XZ compression tools
    zip           # Create .zip archives
  ]);
}
