
# ./modules/programs.nix
# programs & system packages
{ pkgs, ... }:

{
  programs.git.enable = true;

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
    cachix        # Nix binary cache client
    gettext       # GNU gettext utilities (often missing on macOS)

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

  ];
}
