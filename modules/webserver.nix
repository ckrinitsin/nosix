{ config, libs, pkgs, ... }:
{

  users.users.nginx.extraGroups = [ "acme" ];
  services.nginx = {
    enable = true;
    virtualHosts = {
      "krinitsin.com" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/krinitsin.com";
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
