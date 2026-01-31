{ config, pkgs, lib, ... }:

let
  legit-src = pkgs.fetchgit {
    url = "https://git.krinitsin.com/legit.git";
    rev = "15164a810bd16932d651569d321ac18982e1a4ad";
    hash = "sha256-7D9DHl/P+P+EYeKwWRqfVeeIpPoJs6F4UGIR4MX9vBA=";
  };

  legit = pkgs.buildGoModule rec {
    pname = "legit";
    version = "0.1";
    src = legit-src;

    vendorHash = "sha256-6HDD++q8SDHa+akdiM5K/AA3D/rOrLA0YtzM9T6uuUQ=";
  };

  port = 9976;

  conf = (pkgs.formats.yaml { }).generate "something" {
    repo = {
      scanPath = "/var/lib/git-server";
      readme = [ "readme" "README" "README.md" ];
      ignorePattern = [ "^\\..*\\.git" ];
      mainBranch = [ "master" "main" ];
    };
    dirs = {
      static = "${legit-src}/static";
      templates = "${legit-src}/templates";
    };
    meta = {
      title = "git.krinitsin.com";
      syntaxHighlight = "evergarden";
    };
    server = {
      name = "git.krinitsin.com";
      host = "127.0.0.1";
      port = port;
    };
  };
in {
  environment.systemPackages = [ legit ];

  systemd.services.legit = {
    description = "legit";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${legit}/bin/legit --config ${conf}";
      WorkingDirectory = "/var/lib/legit/";
      Restart = "always";
      Environment = [ "PATH=/run/current-system/sw/bin" ];
      User = "git";
    };

  };

  services.nginx = {
    virtualHosts = {
      "git.krinitsin.com" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = { proxyPass = "http://127.0.0.1:${toString port}"; };
      };
    };
  };
}

