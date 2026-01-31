{ config, pkgs, lib, ... }:

let
  shopping-list = pkgs.buildGoModule rec {
    pname = "shopping-list";
    version = "0.1";

    src = pkgs.fetchFromGitHub {
      owner = "ckrinitsin";
      repo = "shopping-list";
      rev = "723d19d5ee37e607c4c4d9c7b4450b7f8a5aa543";
      hash = "sha256-QlhUYiQtONXJRCQ23kWW4yO1u9ZPYz93T+BoEmAkLvE=";
    };

    vendorHash = "sha256-++/WB1HChwnbwJcfghoGNCUzmfmbtqH/7MJTAyj31Rc=";
  };

  port = 10000;
  base_path = "/shopping/";
in {
  environment.systemPackages = [ shopping-list ];

  systemd.services.shopping-list = {
    description = "shopping-list";
    wantedBy = [ "multi-user.target" ];
    environment = {
      GIN_MODE = "release";
      PORT = "${toString port}";
      BASE_PATH = "${base_path}";
    };

    serviceConfig = {
      ExecStart = "${shopping-list}/bin/shopping-list";
      WorkingDirectory = "/var/lib/shopping-list/";
      Restart = "always";
      User = "shopping-list";
      EnvironmentFile = "/secret/shopping_list.env";
    };

  };

  # Create the system user for the service
  users.users.shopping-list = {
    isSystemUser = true;
    group = "shopping-list";
  };
  users.groups.shopping-list = { };

  services.nginx = {
    virtualHosts = {
      "krinitsin.com" = {
        locations.${base_path} = {
          proxyPass = "http://localhost:${toString port}/";
          recommendedProxySettings = true;
        };
      };
    };
  };
}

