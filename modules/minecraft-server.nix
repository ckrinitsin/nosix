{ config, libs, pkgs, unstable, ... }: {

  services.minecraft-server = {
    package = unstable.papermc;
    enable = true;
    eula = true;
    openFirewall = true;

    declarative = true;
    whitelist = {
      Elenal = "65bad3ad-e8af-43b2-8d77-5cd6bcc56c43";
      Karuzo03 = "88ec7147-1bf5-455d-b6b5-c5771796caef";
      samisulkrini = "15848c38-e948-4e37-835d-2b5a14067e75";
      wlafi = "8d38e8f9-8100-4309-acc3-d7690bbc6c32";
    };
    serverProperties = {
      max-players = 4;
      motd = "<3";
      white-list = true;
    };

    dataDir = "/var/lib/minecraft";
  };

  services.monit.config = ''
    check process minecraft-server with matching "papermc"
    start program = "${pkgs.systemd}/bin/systemctl start minecraft-server"
    stop program = "${pkgs.systemd}/bin/systemctl stop minecraft-server"
  '';

}
