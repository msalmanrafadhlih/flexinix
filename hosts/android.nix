{ hostname, ... }:
{
  _module.args = {
    isLinux   = false;
    isWSL     = false;
    isDarwin  = false;
    isAndroid = true;
  };

  imports = [
    ../coreModules
    ./And-${hostname}
  ];
}
