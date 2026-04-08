{ pkgs, lib, ... }: {
  imports = [ ./scripts.nix ];

  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = lib.mkForce "merionette";
      editor = {
        auto-save = false;
        # scrollPastEnd = true;
        text-width = 80;
        true-color = true;
        auto-pairs = true;
        line-number = "relative";

        mouse = true;
        middle-click-paste = true;

        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };

        soft-wrap.enable = false;
        completion-trigger-len = 1;

        end-of-line-diagnostics = "hint";
        idle-timeout = 50;

        popup-border = "all";
        color-modes = true;

        file-picker = {
          hidden = false;
          ignore = false;
          git-ignore = false;
        };

        bufferline = "multiple";
        scroll-lines = 1;

        cursorline = true;
        inline-diagnostics.cursor-line = "warning";

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        statusline = {
          left = [
            "mode"
            "file-name"
            "diagnostics"
            "version-control"
            "read-only-indicator"
            "file-modification-indicator"
          ];
          center = [ ];
          right = [
            "register"
            "file-type"
            "file-encoding"
            "selections"
            "position"
            "position-percentage"
            "spinner"
          ];
          separator = "│";
          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
        };

        indent-guides = {
          render = true;
          character =
            "·"; # Some characters that work well: " ▏", " ┆ ", " ┊ ", " ⸽"
          skip-levels = 1;
        };
      };

      keys = import ./keys.nix;
    };

    languages = import ./language.nix { inherit pkgs; };

    # themes = import ./theme.nix ;

    extraPackages = import ./extraPackages.nix { inherit pkgs; };
  };

  # let yazi handle these files
  home.file.".config/helix/ignore".text = ''
    *.avi
    *.bmp
    *.flac
    *.flv
    *.gif
    *.ico
    *.jpeg
    *.jpg
    *.m4a
    *.mkv
    *.mov
    *.mp3
    *.mp4
    *.ogg
    *.otf
    *.pdf
    *.png
    *.psd
    *.tiff
    *.ttf
    *.wav
    *.webp
    *.woff
    *.woff2
    *.xcf

    node_modules
  '';

  # too short for moving to individual module
  home.packages = with pkgs; [
    nodejs_24
    yarn
    uv
    docker-compose
    powershell
    typst
  ];
}
