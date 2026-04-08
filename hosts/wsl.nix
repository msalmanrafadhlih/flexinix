{ hostname, ... }:

{
  _module.args = {
    isLinux   = false;
    isWSL     = true;
    isDarwin  = false;
    isAndroid = false;
  };

  imports = [
    ../coreModules
    ./Wsl-${hostname}
  ];
}
