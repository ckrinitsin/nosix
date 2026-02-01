{ pkgs, libs, config, ... }: {

  virtualisation.oci-containers.containers."stirling-pdf" = {
    image = "ghcr.io/stirling-tools/stirling-pdf:1.6.0";
    ports = [ "127.0.0.1:5031:8080" ];
    volumes = [ "/var/lib/stirling-pdf:/space" ];
  };

  services.nginx.virtualHosts."pdf.krinitsin.com" = {
    forceSSL = true;
    useACMEHost = "krinitsin.com";
    locations."/" = {
      proxyPass = "http://localhost:5031";
      recommendedProxySettings = true;
    };
  };

  security.acme.certs."krinitsin.com".extraDomainNames =
    [ "pdf.krinitsin.com" ];

  services.monit.config = ''
    check process stirling-pdf with matching "stirling-pdf"
    start program = "${pkgs.systemd}/bin/systemctl start stirling-pdf"
    stop program = "${pkgs.systemd}/bin/systemctl stop stirling-pdf"
  '';
}
