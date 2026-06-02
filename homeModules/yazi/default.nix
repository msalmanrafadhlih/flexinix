{ pkgs, inputs, ... }:
let
  inp = inputs.racooonfig.inputs;
in
{
  home.packages = with pkgs; [
    trash-cli
    ouch
    glow
    exiftool
    eza
  ];

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";

    plugins = with pkgs.yaziPlugins; {
      full-border = full-border;
      starship = starship;
      mount = mount;
      restore = restore;
      ouch = ouch;
      piper = piper;
      compress = inp.yazi-compress;
    };

    initLua = builtins.readFile ./init.lua;

    theme = {
      flavor = {
        light = "catppuccin-frappe";
        dark = "catppuccin-macchiato";
      };
    };

    flavors =
      let
        flav = inp.yazi-flavors;
      in
      {
        catppuccin-macchiato = "${flav}/catppuccin-macchiato.yazi";
        catppuccin-frappe = "${flav}/catppuccin-frappe.yazi";
        catppuccin-latte = "${flav}/catppuccin-latte.yazi";
        catppuccin-mocha = "${flav}/catppuccin-mocha.yazi";
      };

    settings = {
      mgr = {
        ratio = [
          2
          3
          4
        ];
        show_hidden = false;
        title_format = "";
        show_symlink = true;
        sort_by = "natural";
        sort_reverse = false;
        sort_dirs_first = true;
        linemode = "size_and_mtime";
      };

      opener = {
        play = [
          {
            run = "xdg-open %s"; # Fix: $@ → %s (Yazi format baru)
            orphan = true;
            desc = "open";
            for = "linux";
          }
        ];
      };

      plugin = {
        prepend_previewers = [
          # directory previewer
          {
            url = "*/";
            # Fix: single quotes '$1' → double quotes "$1" via Nix indented string
            run = ''piper -- eza -TL=2 --color=always --icons=always --group-directories-first --no-quotes -a "$1"'';
          }

          # archive previewers
          {
            mime = "application/*zip";
            run = "ouch";
          }
          {
            mime = "application/x-tar";
            run = "ouch";
          }
          {
            mime = "application/x-bzip2";
            run = "ouch";
          }
          {
            mime = "application/x-7z-compressed";
            run = "ouch";
          }
          {
            mime = "application/x-rar";
            run = "ouch";
          }
          {
            mime = "application/x-xz";
            run = "ouch";
          }
          {
            mime = "application/xz";
            run = "ouch";
          }

          # markdown with glow
          {
            url = "*.md";
            # Fix: '$1' → "$1"
            run = ''piper -- CLICOLOR_FORCE=1 COLORTERM=truecolor glow -w=$w -s=dark "$1"'';
          }

          {
            url = "*.csv";
            # Fix: '$1' → "$1"
            run = ''piper -- bat -p --color=always "$1"'';
          }
        ];
      };
    };

    keymap = {
      mgr = {
        prepend_keymap = [
          {
            on = "M";
            run = "plugin mount";
            desc = "Mount drives";
          }

          {
            on = "u";
            run = "plugin restore";
            desc = "Restore last deleted files/folders";
          }

          # compress.yazi
          {
            on = [
              "-"
              "c"
            ];
            run = "plugin compress";
            desc = "Archive selected files";
          }
          {
            on = [
              "-"
              "p"
            ];
            run = "plugin compress -p";
            desc = "Archive with password";
          }
          {
            on = [
              "-"
              "h"
            ];
            run = "plugin compress -ph";
            desc = "Archive with password and header";
          }
          {
            on = [
              "-"
              "l"
            ];
            run = "plugin compress -l";
            desc = "Archive with compression level";
          }
        ];
      };
    };
  };
}
