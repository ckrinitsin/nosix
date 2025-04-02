{ pkgs, libs, config, ... }:
{

  services.syncthing = {
    enable = true;
    guiAddress = "localhost:8384";
    dataDir = "/var/lib/syncthing";
    openDefaultPorts = true;
  };
  
  services.nginx.virtualHosts."syncthing.krinitsin.com" = {
    forceSSL = true;
    useACMEHost = "krinitsin.com";
    locations."/".proxyPass = "https://localhost:8384";
  };

  security.acme.certs."krinitsin.com".extraDomainNames = [ "syncthing.krinitsin.com" ];

  services.monit.config = ''
    check process syncthing with matching "syncthing"
    start program = "${pkgs.systemd}/bin/systemctl start syncthing"
    stop program = "${pkgs.systemd}/bin/systemctl stop syncthing"
  '';

}
