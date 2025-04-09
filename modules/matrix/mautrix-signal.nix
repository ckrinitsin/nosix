{ pkgs, libs, config, ... }:
{

  services.mautrix-signal = {
    enable = true;
    settings = {
    
      appservice = {
        as_token = "";
        bot = {
          displayname = "Signal Bridge Bot";
          username = "signalbot";
        };
        hostname = "[::]";
        hs_token = "";
        id = "signal";
        port = 29328;
        username_template = "signal_{{.}}";
      };

      bridge = {
        command_prefix = "!signal";
        permissions = {
          "krinitsin.com" = "admin";
        };
        relay = {
          enabled = true;
        };
      };

      database = {
        type = "sqlite3";
        uri = "file:/var/lib/mautrix-signal/mautrix-signal.db";
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

      network = {
        displayname_template = "{{or .ProfileName .PhoneNumber \"Unknown user\"}}";
      };

    };
  };

}
