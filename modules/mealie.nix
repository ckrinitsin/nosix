{ config, libs, pkgs, ... }:
let
  unstable = import <nixos-unstable> {};
in
{

  services.mealie = {
    enable = true;
    package = unstable.mealie;
  };

  services.nginx.virtualHosts."recipes.krinitsin.com" = {
    forceSSL = true;
    useACMEHost = "krinitsin.com";
    serverAliases = [ "rezepte.krinitsin.com" ];
    locations."/".proxyPass = "http://localhost:9000";
  };

  security.acme.certs."krinitsin.com".extraDomainNames = [ "recipes.krinitsin.com" "rezepte.krinitsin.com" ];

}
