# ./configuration.nix
{
  isWSL,
  isLinux,
  isDarwin,
  isAndroid,
  lib,
  ...
}:
{
  imports = [
    # ./nginx.nix
    ./system-packages.nix
    ./devenv.nix
    ./shell.nix
    ./openssh.nix
    ./settings.nix

  ]
  ++ lib.optionals isDarwin [
    ./darwin.nix

  ]
  ++ lib.optionals isWSL [

  ]
  ++ lib.optionals isAndroid [
    ./android.nix

  ]
  ++ lib.optionals isLinux [
    # ./kanata.nix
    ./users.nix
    ./nixos.nix
    ./virtualisation.nix
    ./locale.nix
    ./nix-ld.nix
    ./fonts.nix
    ./sudo.nix
  ];
}
