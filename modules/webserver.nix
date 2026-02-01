{ config, libs, pkgs, ... }:
let
  webpage-root = pkgs.fetchgit {
    url = "https://git.krinitsin.com/krinitsin.com.git";
    rev = "848c234a10bc80889721533fbc0174cfcff059bc";
    hash = "sha256-s8MXHyjYZ9Ovfsk6lSajh3PB5RS7xhlLnGAIESYCPak=";
  };
in {

  users.users.nginx.extraGroups = [ "acme" ];
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "krinitsin.com" = {
        forceSSL = true;
        enableACME = true;
        root = "${webpage-root}";
        serverAliases = [ "www.krinitsin.com" ];
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "christian@krinitsin.xyz";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.monit.config = ''
    check process nginx with pidfile /var/run/nginx/nginx.pid
    start program = "${pkgs.systemd}/bin/systemctl start nginx"
    stop program = "${pkgs.systemd}/bin/systemctl stop nginx"
    if failed host 127.0.0.1 port 443 then restart
  '';
}
