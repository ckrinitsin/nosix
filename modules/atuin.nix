{ pkgs, libs, config, ... }:
{

  services.atuin = {
    enable = true;
    port = 8889;
    openRegistration = true;
  };

  services.nginx.virtualHosts."atuin.krinitsin.com" = {
    forceSSL = true;
    useACMEHost = "krinitsin.com";
    locations."/".proxyPass = "http://localhost:8889";
  };

  security.acme.certs."krinitsin.com".extraDomainNames = [ "atuin.krinitsin.com" ];

  services.monit.config = ''
    check process atuin with matching "atuin"
    start program = "${pkgs.systemd}/bin/systemctl start atuin"
    stop program = "${pkgs.systemd}/bin/systemctl stop atuin"
  '';

}
