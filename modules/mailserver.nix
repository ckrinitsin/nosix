{ config, pkgs, ... }: {
  imports = [
    (builtins.fetchTarball {
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-25.05/nixos-mailserver-nixos-25.05.tar.gz";
      sha256 = "0jpp086m839dz6xh6kw5r8iq0cm4nd691zixzy6z11c4z2vf8v85";
    })
  ];

  mailserver = {
    enable = true;
    fqdn = "mail.krinitsin.com";
    domains = [ "krinitsin.com" ];
    certificateScheme = "acme-nginx";
    lmtpSaveToDetailMailbox = "no";

    # To create the password hashes, use nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "mail@krinitsin.com" = {
        hashedPasswordFile = "/secret/mail@krinitsin.com";
        aliases = [ "postmaster@krinitsin.com" "christian@krinitsin.com" "@krinitsin.com" ];
      };
      "wladislaw@krinitsin.com" = {
        hashedPasswordFile = "/secret/wladislaw@krinitsin.com";
      };
      "vaultwarden@krinitsin.com" = {
        hashedPasswordFile = "/secret/vaultwarden@krinitsin.com";
	sendOnly = true;
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

  services.monit.config = ''
    check process postfix with pidfile /var/lib/postfix/queue/pid/master.pid
          start program = "${pkgs.systemd}/bin/systemctl start postfix"
          stop program = "${pkgs.systemd}/bin/systemctl stop postfix"
          if failed port 25 protocol smtp for 5 cycles then restart

    check process dovecot with pidfile /var/run/dovecot2/master.pid
          start program = "${pkgs.systemd}/bin/systemctl start dovecot2"
          stop program = "${pkgs.systemd}/bin/systemctl stop dovecot2"
          if failed host mail.krinitsin.com port 993 type tcpssl sslauto protocol imap for 5 cycles then restart

    check process rspamd with matching "rspamd: main process"
          start program = "${pkgs.systemd}/bin/systemctl start rspamd"
          stop program = "${pkgs.systemd}/bin/systemctl stop rspamd"
  '';

  security.acme.certs."krinitsin.com".extraDomainNames = [ "webmail.krinitsin.com" ];
}
