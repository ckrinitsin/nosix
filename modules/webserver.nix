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
	locations."/shopping/api/".proxyPass = "http://krinitsin.com:5000";
      };

      "recipes.krinitsin.com" = {
        forceSSL = true;
	useACMEHost = "krinitsin.com";
	root = "/var/www/recipes.krinitsin.com";
	serverAliases = [ "rezepte.krinitsin.com" ]
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "christian@krinitsin.xyz";
    certs."krinitsin.com".extraDomainNames = [ "shopping.krinitsin.com" "webmail.krinitsin.com" ];
  };

  systemd.services.flask = {
    enable = true;
    wantedBy = ["default.target"];
    serviceConfig.ExecStart = ''/run/current-system/sw/bin/flask --app /var/www/krinitsin.com/shopping/app.py run -h krinitsin.com'';
  };

  networking.firewall.allowedTCPPorts = [ 80 443 5000 ];
}
