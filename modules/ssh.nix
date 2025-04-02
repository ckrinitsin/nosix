{ config, libs, pkgs, ... }:
{

  environment.systemPackages = [ pkgs.openssh ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  services.monit.config = ''
    check process sshd with pidfile /var/run/sshd.pid
    start program  "${pkgs.systemd}/bin/systemctl start sshd"
    stop program  "${pkgs.systemd}/bin/systemctl stop sshd"
    if failed port 22 protocol ssh for 2 cycles then restart
  '';
}
