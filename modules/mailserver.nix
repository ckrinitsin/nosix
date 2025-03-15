{ config, pkgs, ... }: {
  imports = [
    (builtins.fetchTarball {
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-24.11/nixos-mailserver-nixos-24.11.tar.gz";
      sha256 = "05k4nj2cqz1c5zgqa0c6b8sp3807ps385qca74fgs6cdc415y3qw";
    })
  ];

  mailserver = {
    enable = true;
    fqdn = "mail.krinitsin.com";
    domains = [ "krinitsin.com" ];
    certificateScheme = "acme-nginx";

    # To create the password hashes, use nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "mail@krinitsin.com" = {
        hashedPasswordFile = "/secret/mail@krinitsin.com";
        aliases = [ "postmaster@krinitsin.com" "christian@krinitsin.com" ];
      };
      "wladislaw@krinitsin.com" = {
        hashedPasswordFile = "/secret/wladislaw@krinitsin.com";
      };
    };
  };

  services.roundcube = {
     enable = true;
     hostName = "webmail.krinitsin.com";
     extraConfig = ''
       $config['smtp_host'] = "tls://${config.mailserver.fqdn}";
       $config['smtp_user'] = "%u";
       $config['smtp_pass'] = "%p";
     '';
  };

  security.acme.certs."krinitsin.com".extraDomainNames = [ "webmail.krinitsin.com" ];
}
