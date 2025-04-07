{ pkgs, libs, config, ... }:
{

  services.stirling-pdf = {
    enable = true;
    environment = {
      SERVER_PORT = 5031;
    };
  };

  services.nginx.virtualHosts."pdf.krinitsin.com" = {
    forceSSL = true;
    useACMEHost = "krinitsin.com";
    locations."/".proxyPass = "http://localhost:5031";
  };

  security.acme.certs."krinitsin.com".extraDomainNames = [ "pdf.krinitsin.com" ];

  services.monit.config = ''
    check process stirling-pdf with matching "stirling-pdf"
    start program = "${pkgs.systemd}/bin/systemctl start stirling-pdf"
    stop program = "${pkgs.systemd}/bin/systemctl stop stirling-pdf"
  '';
}
