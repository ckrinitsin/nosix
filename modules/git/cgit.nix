{ config, pkgs, lib , ... }:
{

  services.cgit.git = {
    enable = true;
    package = pkgs.cgit-pink;
    user = "git";
    group = "git";
    scanPath = "/null";

    extraConfig = ''
      root-title=git.krinitsin
      root-desc=github mirror
      footer=
      logo=
      css=/cur-cgit.css

      clone-url=git@krinitsin.com:$CGIT_REPO_URL
      snapshots=tar.gz zip

      cache-size=1000

      enable-index-owner=0
      enable-http-clone=0
      enable-blame=1
      enable-commit-graph=1


      enable-log-filecount=1
      enable-log-linecount=1
      branch-sort=age

      max-stats=quarter

      source-filter=${pkgs.cgit}/lib/cgit/filters/syntax-highlighting.py
      about-filter=${pkgs.cgit}/lib/cgit/filters/about-formatting.sh

      readme=:README.md
      readme=:readme.md

      enable-follow-links=1
      enable-git-config=1
      remove-suffix=1

      scan-path=/var/lib/git-server
    '';

    nginx = {
      virtualHost = "git.krinitsin.com";
      location = "/";
    };
  };

  services.nginx.virtualHosts."git.krinitsin.com" = {
    forceSSL = true;
    useACMEHost = "krinitsin.com";
    locations."= /cur-cgit.css".alias = /var/www/cur-cgit.css;
  };

  security.acme.certs."krinitsin.com".extraDomainNames = [ "git.krinitsin.com" ];

}
