{ ... }:

{
  services.nginx = {
    user = "service";
    enable = true;
    virtualHosts."example@gmaildummy.work" = {
      useACMEHost = "example@gmaildummy.work";
      forceSSL = true;
      locations."/" = {
        root = "/data/webserver/";
        index = "index.txt";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "example@gmaildummy.work";
    certs."" = {
      dnsProvider = "cloudflare";
      credentialsFile = "/etc/secrets/cf.env";
      dnsPropagationCheck = true;
    };
  };
}
