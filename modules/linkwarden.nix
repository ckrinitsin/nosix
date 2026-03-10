{ config, libs, pkgs, ... }: {

  services.linkwarden = {
    enable = true;
    port = 7845;
    secretFiles = {
        NEXTAUTH_SECRET = "/secret/linkwarden_secret";
    };
  };

  services.nginx.virtualHosts."linkwarden.krinitsin.com" = {
    forceSSL = true;
    useACMEHost = "krinitsin.com";
    locations."/".proxyPass = "http://localhost:7845";
  };

  security.acme.certs."krinitsin.com".extraDomainNames =
    [ "linkwarden.krinitsin.com" ];

}
