{ pkgs, libs, config, ... }:
{

  services.silverbullet = {
    enable = true;
    listenPort = 3000;
    listenAddress = "localhost";
    envFile = "/secret/silverbullet.env";
  };
  
  services.nginx.virtualHosts."notes.krinitsin.com" = {
    forceSSL = true;
    useACMEHost = "krinitsin.com";
    locations."/".proxyPass = "http://localhost:3000";
  };

  security.acme.certs."krinitsin.com".extraDomainNames = [ "notes.krinitsin.com" ];

  networking.firewall.allowedTCPPorts = [ 3000 ];

  services.monit.config = ''
    check process silverbullet with matching "silverbullet"
    start program = "${pkgs.systemd}/bin/systemctl start silverbullet"
    stop program = "${pkgs.systemd}/bin/systemctl stop silverbullet"
  '';

}
