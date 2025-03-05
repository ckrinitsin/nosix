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
	serverAliases = [ "rezepte.krinitsin.com" ];
        locations."/".proxyPass = "http://localhost:9000";
      };
      
      "syncthing.krinitsin.com" = {
        forceSSL = true;
	useACMEHost = "krinitsin.com";
        locations."/".proxyPass = "https://localhost:8384";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "christian@krinitsin.xyz";
    certs."krinitsin.com".extraDomainNames = [ "recipes.krinitsin.com" "rezepte.krinitsin.com" "webmail.krinitsin.com" "syncthing.krinitsin.com" ];
  };


  environment.systemPackages = with pkgs; [
    python312
    python312Packages.flask
  ];

  systemd.services.flask = {
    enable = true;
    wantedBy = ["default.target"];
    serviceConfig.ExecStart = ''/run/current-system/sw/bin/flask --app /var/www/krinitsin.com/shopping/app.py run -h krinitsin.com'';
  };

  networking.firewall.allowedTCPPorts = [ 80 443 5000 ];
}
