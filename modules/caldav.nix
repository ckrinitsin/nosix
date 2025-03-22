{ config, pkgs, libs, ... }:
{

  services.radicale = {
    enable = true;
    settings.server.hosts = [ "0.0.0.0:5232" ];
    settings.server.ssl = "False";
    settings.auth = {
      type = "htpasswd";
      htpasswd_filename = "/secret/caldav_users";
      htpasswd_encryption = "plain";
    };
  };

  services.nginx.virtualHosts."caldav.krinitsin.com" = {
    forceSSL = true;
    useACMEHost = "krinitsin.com";
    locations."/" = {
      proxyPass = "http://localhost:5232";
      recommendedProxySettings = true;
    };
  };

  security.acme.certs."krinitsin.com".extraDomainNames = [ "caldav.krinitsin.com" ];

}
