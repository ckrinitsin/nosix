{ pkgs, libs, config, ... }:
{

  imports = 
    [
      ./mautrix-whatsapp.nix
      ./mautrix-signal.nix
      ./element.nix
    ];

  nixpkgs.config.permittedInsecurePackages = [ "olm-3.2.16" ];

  services.postgresql = {
    enable = true;
  };

  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = "krinitsin.com";
      public_baseurl = "https://matrix.krinitsin.com/";
      presence.enabled = false;
    };
    extraConfigFiles = [ "/secret/matrix" ];
  };

  services.nginx.virtualHosts."matrix.krinitsin.com" = {
    forceSSL = true;
    useACMEHost = "krinitsin.com";
    locations."/".proxyPass = "http://localhost:8008";
  };

  security.acme.certs."krinitsin.com".extraDomainNames = [ "matrix.krinitsin.com" ];

  services.monit.config = ''
    check process synapse with matching "synapse"
    start program = "${pkgs.systemd}/bin/systemctl start synapse"
    stop program = "${pkgs.systemd}/bin/systemctl stop synapse"
  '';

}
