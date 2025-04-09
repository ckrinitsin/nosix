{ pkgs, libs, config, ... }:
{

  services.mautrix-whatsapp = {
    enable = true;
    settings = {

      appservice = {
        as_token = "";
        bot = {
          displayname = "WhatsApp Bridge Bot";
          username = "whatsappbot";
        };
        database = {
          type = "sqlite3";
          uri = "/var/lib/mautrix-whatsapp/mautrix-whatsapp.db";
        };
        hostname = "[::]";
        hs_token = "";
        id = "whatsapp";
        port = 29318;
      };

      bridge = {
        command_prefix = "!wa";
        displayname_template = "{{if .BusinessName}}{{.BusinessName}}{{else if .PushName}}{{.PushName}}{{else}}{{.JID}}{{end}} (WA)";
        double_puppet_server_map = { };
        login_shared_secret_map = { };
        permissions = {
          "krinitsin.com" = "admin";
        };
        relay = {
          enabled = true;
        };
        username_template = "whatsapp_{{.}}";
      };

      homeserver = {
        address = "http://localhost:8008";
      };

      logging = {
        min_level = "info";
        writers = [
          {
            format = "pretty-colored";
            time_format = " ";
            type = "stdout";
          }
        ];
      };

    };
  };

}
