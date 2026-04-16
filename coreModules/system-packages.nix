# ./modules/programs.nix
# programs & system packages
{ isWSL, pkgs, lib, isDarwin, isLinux, isAndroid, ... }:

{
  programs = {
    git.enable = true;

  } // (if isLinux then {
    # firefox.enable = true;
    thunderbird.enable = true;
  } else {});


  environment.systemPackages = with pkgs; [

    # User-facing stuff that you really really want to have
    helix # or some other editor, e.g. nano or neovim

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
    atuin         # smart command shell histories
    jujutsu       # Smart Git

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

  ] ++ (lib.optionals isDarwin [

    # ======= macOS ONLY
    cachix        # Nix binary cache client
    gettext       # GNU gettext utilities (often missing on macOS)

  ]) ++ (lib.optionals isWSL [

    # ======= wsl only

  ]) ++ (lib.optionals isAndroid [

    # Some common stuff that people expect to have
    procps
    killall
    diffutils
    findutils
    utillinux
    tzdata
    hostname
    man
    gnugrep
    gnupg
    gnused
    gnutar
    bzip2
    gzip
    xz
    zip
    unzip

  ]) ++ (lib.optionals isLinux [

    # ======= LINUX ONLY
    acpi          # Show battery / ACPI power information
    psmisc        # Process utilities (killall, pstree)
    inetutils     # Networking utilities (telnet, ftp, etc)
    iputils       # Network utilities (ping, arping)

    # ======= ARCHIVES
    gnutar        # GNU tar archiver
    p7zip         # 7z compression utility
    unzip         # Extract .zip archives
    xz            # XZ compression tools
    zip           # Create .zip archives
  ]);
}
