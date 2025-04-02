{ config, libs, pkgs, ...}:
{

  services.polaris = {
    enable = true;
    port = 5051;
    settings = {
      settings.album_art_pattern = "(cover|front|folder)\.(jpeg|jpg|png|bmp|gif)";
      mount_dirs = [
        {
	  name = "Music";
	  source = "/var/music";
	}
      ];
    };
  };

  services.nginx.virtualHosts."music.krinitsin.com" = {
    forceSSL = true;
    useACMEHost = "krinitsin.com";
    locations."/".proxyPass = "http://localhost:5051";
  };

  security.acme.certs."krinitsin.com".extraDomainNames = [ "music.krinitsin.com" ];

  services.monit.config = ''
    check process polaris with matching "polaris"
    start program = "${pkgs.systemd}/bin/systemctl start polaris"
    stop program = "${pkgs.systemd}/bin/systemctl stop polaris"
  '';

}
