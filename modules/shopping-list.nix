{ config, pkgs, lib, ... }:

let
  shopping-list = pkgs.buildGoModule rec {
    pname = "shopping-list";
    version = "0.1";

    src = pkgs.fetchFromGitHub {
      owner = "ckrinitsin";
      repo = "shopping-list";
      rev = "26d70f0ea7b8dc84b2451b3965d9e81d7b25a9a8";
      hash = "sha256-HQqzia1KEWLu5y726HIbMH6YtcRBXxwSgURci/xY6x4=";
    };

    vendorHash = "sha256-++/WB1HChwnbwJcfghoGNCUzmfmbtqH/7MJTAyj31Rc=";
  };

  port = 10000;
  base_path = "/shopping/";
in
{
  environment.systemPackages = [
    shopping-list
  ];

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
  users.groups.shopping-list = {};

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

