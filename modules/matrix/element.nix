{ pkgs, libs, config, ... }:
let
  clientConfig."m.homeserver".base_url = "https://matrix.krinitsin.com/";
in
{

  services.nginx.virtualHosts."element.krinitsin.com" = {
    forceSSL = true;
    useACMEHost = "krinitsin.com";
    root = pkgs.element-web.override {
      conf = {
        default_server_config = clientConfig;
      };
    };
  };

  security.acme.certs."krinitsin.com".extraDomainNames = [ "element.krinitsin.com" ];

}
