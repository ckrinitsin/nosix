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
    locations."/" = {
      extraConfig = ''
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $http_connection;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';

      proxyPass = "http://localhost:8222";
    };
  };

  security.acme.certs."krinitsin.com".extraDomainNames = [ "vault.krinitsin.com" ];

}
