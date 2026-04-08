{ hostname, ... }:

{
  _module.args = {
    isLinux   = false;
    isWSL     = false;
    isDarwin  = true;
    isAndroid = false;
  };

  imports = [
    ../coreModules
    ./Drw-${hostname}
  ];
}
