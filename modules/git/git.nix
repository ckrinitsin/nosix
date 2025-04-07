{ pkgs, libs, config, ... }:
{

  users.users.git = {
    isSystemUser = true;
    group = "git";
    home = "/var/lib/git-server";
    createHome = true;
    shell = "${pkgs.git}/bin/git-shell";
    openssh.authorizedKeys.keys = config.users.users.admin.openssh.authorizedKeys.keys;
  };

  users.groups.git = {};

  services.openssh.extraConfig = ''
    Match user git
      AllowTcpForwarding no
      AllowAgentForwarding no
      PasswordAuthentication no
      PermitTTY no
      X11Forwarding no
  '';

  systemd.services.github-mirror = {
    enable = true;
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = ''/run/current-system/sw/bin/bash /var/lib/git-server/mirror-script.sh'';
      User = ''git'';
      Group = ''git'';
    };
  };
}
