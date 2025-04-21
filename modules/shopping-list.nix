{ config, pkgs, lib, ... }:

let
  shopping-list = pkgs.buildGoModule rec {
    pname = "shopping-list";
    version = "0.1";

    src = pkgs.fetchFromGitHub {
      owner = "ckrinitsin";
      repo = "shopping-list";
      rev = "1e974f70a6c262d0b5db8b177ebb02b46446bfb0";
      hash = "sha256-QtLOYo7shRoBpExUh4zvkroEjcmfqStRXELQqeAcMs8=";
    };

    vendorHash = "sha256-Q8UzufKbUMnpduciwu9uyHq8WpjgSQWmcJGVdlxs0kk=";
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
	  basicAuthFile = "/secret/shopping_auth";
	  proxyPass = "http://localhost:${toString port}/";
	  recommendedProxySettings = true;
	};
      };
    };
  };
}

