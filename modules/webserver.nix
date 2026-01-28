{ config, libs, pkgs, ... }:
let
  webpage-root = pkgs.fetchgit {
    url = "https://git.krinitsin.com/krinitsin.com.git";
    rev = "e7529a549dc1e4fed511efaad82d2e57abdb656e";
    hash = "sha256-0xyUrU7SCqGE8jkMphrvAxy/Vuph4ttSYDNPrTM60+Y=";
  };
in
{

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
