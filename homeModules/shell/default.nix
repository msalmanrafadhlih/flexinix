{ isDarwin, lib, ... }:
{
  imports = [
    ./bash.nix  # enable bash too just so home-manager can manage it
    ./zsh.nix
  ] ++ lib.optionals isDarwin [
    ./fish.nix
  ];

  # shell completion 
  programs.carapace = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # better cd
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  # better ls
  programs.eza = {
    enable = true;
    icons = "auto";

    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
