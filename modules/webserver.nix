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

	locations."/shopping/".basicAuthFile = "/secret/shopping_auth";
	locations."/shopping/api/" = {
	  proxyPass = "http://127.0.0.1:5000";
	  basicAuthFile = "/secret/shopping_auth";
	};

	locations."/mensa/api/".proxyPass = "http://127.0.0.1:5000";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "christian@krinitsin.xyz";
  };

  systemd.services.flask-backend = {
    enable = true;
    wantedBy = ["multi-user.target"];
    serviceConfig.ExecStart = ''/var/flask-backend/result/bin/app.py'';
  };

  networking.firewall.allowedTCPPorts = [ 80 443 5000 ];

  services.monit.config = ''
    check process nginx with pidfile /var/run/nginx/nginx.pid
    start program = "${pkgs.systemd}/bin/systemctl start nginx"
    stop program = "${pkgs.systemd}/bin/systemctl stop nginx"
    if failed host 127.0.0.1 port 443 then restart
  '';
}
