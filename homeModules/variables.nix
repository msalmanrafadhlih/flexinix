{ pkgs, isDarwin, flakeRoot, ... }:
let
  # For our MANPAGER env var
  # https://github.com/sharkdp/bat/issues/1145
  manpager = pkgs.writeShellScriptBin "manpager" (if isDarwin then ''
      col -bx | bat -l man -p
    '' else ''
      col -bx | bat --language man --style plain
    '');
in

{
  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------
  home.sessionVariables = {
    EDITOR = flakeRoot.editor;
    PATH="/etc/nixos/result/bin:$PATH";
  } // (if isDarwin then {
    # See: https://github.com/NixOS/nixpkgs/issues/390751
    PAGER = "less -FirSwX";
    DISPLAY = "nixpkgs-390751";
    MANPAGER = "${manpager}/bin/manpager";
  } else {});
}
