{ pkgs, libs, config, ... }:
{

  services.monit = {
    enable = true;
    config = ''
      set mailserver localhost port 25 username admin
      set alert mail@krinitsin.com

      set daemon 120 with start delay 60
      set mailserver
          localhost

      set httpd port 2812 and use address localhost
          allow localhost

      check filesystem root with path /
          if space usage > 80% then alert
          if inode usage > 80% then alert

      check system $HOST
          if cpu usage > 95% for 10 cycles then alert
          if memory usage > 75% for 5 cycles then alert
          if swap usage > 20% for 10 cycles then alert
          if loadavg (1min) > 90 for 15 cycles then alert
          if loadavg (5min) > 80 for 10 cycles then alert
          if loadavg (15min) > 70 for 8 cycles then alert

      check network network interface ens3
    '';
  };
  
  services.nginx.virtualHosts."status.krinitsin.com" = {
    forceSSL = true;
    useACMEHost = "krinitsin.com";
    basicAuthFile = "/secret/monit";
    locations."/".proxyPass = "http://localhost:2812";
  };

  security.acme.certs."krinitsin.com".extraDomainNames = [ "status.krinitsin.com" ];

}
