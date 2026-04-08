{ hostname, ... }:

{
  _module.args = {
    isLinux   = true;
    isWSL     = false;
    isDarwin  = false;
    isAndroid = false;
  };

  imports = [
    ../coreModules
    ./Nix-${hostname}
  ];
}
