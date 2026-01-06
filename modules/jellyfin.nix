{ pkgs, libs, config, ... }:
{

  services.jellyfin.enable = true;

  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
  
  services.nginx.virtualHosts."jelly.krinitsin.com" = {
    forceSSL = true;
    useACMEHost = "krinitsin.com";
    locations."/".proxyPass = "http://localhost:8096";
  };

  security.acme.certs."krinitsin.com".extraDomainNames = [ "jelly.krinitsin.com" ];

  services.monit.config = ''
    check process jellyfin with matching "jellyfin"
    start program = "${pkgs.systemd}/bin/systemctl start jellyfin"
    stop program = "${pkgs.systemd}/bin/systemctl stop jellyfin"
  '';

}
