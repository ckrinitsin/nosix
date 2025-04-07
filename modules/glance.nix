{ pkgs, libs, config, ... }:
let
  unstable = import <nixos-unstable> {};
in
{

  services.glance = {
    enable = true;
    package = unstable.glance;
    settings = {
      server = {
        host = "localhost";
        port = 5678;
        assets-path = "/var/glance-assets";
        base_url = "dash.krinitsin.com";
      };

      theme = {
        background-color = "204 14 20";
        primary-color = "41 32 75";
        positive-color = "172 29 61";
        negative-color = "358 69 68";
        text-saturation-multiplier = 1.0;
      };
    };

    settings.pages = [
      {
        name = "Home";
        columns = [
          {
            size = "small";
            widgets = [
              {
                type = "calendar";
              }
              {
                type = "iframe";
                title = "Mensa";
                source = "https://krinitsin.com/mensa/";
                height = 350;
              }
            ];
          }
          {
            size = "full";
            widgets = [
              {
                location = "Munich, Germany";
                type = "weather";
              }
              {
                type = "lobsters";
                title = "News";
                sort-by = "hot";
              }
            ];
          }
          {
            size = "small";
            widgets = [
              {
                cache = "1m";
                title = "Services";
                sites = [
                  {
                    title = "Vaultwarden";
                    url = "https://vault.krinitsin.com";
                    icon = "/assets/vaultwarden.png";
                  }
                  {
                    title = "Git";
                    url = "https://git.krinitsin.com";
                    icon = "si:git";
                  }
                  {
                    title = "Mealie";
                    url = "https://recipes.krinitsin.com";
                    icon = "/assets/mealie.png";
                  }
                  {
                    title = "PDF";
                    url = "https://pdf.krinitsin.com";
                    icon = "di:stirling-pdf";
                  }
                  {
                    title = "Polaris";
                    url = "https://music.krinitsin.com";
                    icon = "/assets/polaris.webp";
                  }
                  {
                    title = "Radicale";
                    url = "https://caldav.krinitsin.com";
                    icon = "/assets/radicale.png";
                  }
                  {
                    title = "Monit";
                    url = "https://status.krinitsin.com/";
                    check-url = "https://google.com";
                    icon = "/assets/monit.png";
                  }
                  {
                    title = "Shopping List";
                    url = "https://krinitsin.com/shopping/";
                    check-url = "https://google.com";
                    icon = "/assets/monit.png";
                  }
                  {
                    title = "Mensa";
                    url = "https://krinitsin.com/mensa/";
                    icon = "/assets/monit.png";
                  }
                  {
                    title = "Webmail";
                    url = "https://webmail.krinitsin.com";
                    icon = "si:roundcube";
                  }
                ];
                type = "monitor";
              }
            ];
          }
        ];
      }
    ];

    openFirewall = true;
  };
  
  services.nginx.virtualHosts."dash.krinitsin.com" = {
    forceSSL = true;
    useACMEHost = "krinitsin.com";
    locations."/".proxyPass = "http://localhost:5678";
  };

  security.acme.certs."krinitsin.com".extraDomainNames = [ "dash.krinitsin.com" ];

  services.monit.config = ''
    check process glance with matching "glance"
    start program = "${pkgs.systemd}/bin/systemctl start glance"
    stop program = "${pkgs.systemd}/bin/systemctl stop glance"
  '';
}
