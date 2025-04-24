{ pkgs, libs, config, ... }:
{

  virtualisation.docker.enable = true;

  virtualisation.oci-containers = {
    backend = "docker";
    containers."silverbullet" = {
      image = "ghcr.io/silverbulletmd/silverbullet:v2";
      ports = [ "127.0.0.1:3000:3000" ];
      volumes = [ "/var/lib/silverbullet:/space" ];
      environmentFiles = [ "/secret/silverbullet.env" ];
    };
  };
  
  services.nginx.virtualHosts."notes.krinitsin.com" = {
    forceSSL = true;
    useACMEHost = "krinitsin.com";
    locations."/".proxyPass = "http://localhost:3000";
  };

  security.acme.certs."krinitsin.com".extraDomainNames = [ "notes.krinitsin.com" ];

  services.monit.config = ''
    check process silverbullet with matching "silverbullet"
    start program = "${pkgs.systemd}/bin/systemctl start silverbullet"
    stop program = "${pkgs.systemd}/bin/systemctl stop silverbullet"
  '';

}
