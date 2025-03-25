{ config, libs, pkgs, ...}:
{

  services.vaultwarden = {
    enable = true;
    config = {
      SIGNUPS_ALLOWED = false;
      DOMAIN = "https://vault.krinitsin.com";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
    };
    environmentFile = "/secret/vaultwarden.env";
  };

  services.nginx.virtualHosts."vault.krinitsin.com" = {
    forceSSL = true;
    useACMEHost = "krinitsin.com";
    locations."/".proxyPass = "http://localhost:8222";
  };

  security.acme.certs."krinitsin.com".extraDomainNames = [ "vault.krinitsin.com" ];

}
