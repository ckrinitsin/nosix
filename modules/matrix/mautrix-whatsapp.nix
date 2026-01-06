{ pkgs, libs, config, ... }:
{

  services.mautrix-whatsapp = {
    enable = true;
    registerToSynapse = true;
    settings = {
      appservice = {
    ephemeral_events = false;
    id = "whatsapp";
  };
  backfill = {
    enabled = true;
  };
  bridge = {
    mute_only_on_create = false;
    permissions = {
      "krinitsin.com" = "admin";
    };
    relay.enabled = true;
    private_chat_portal_meta = true;
  };
        database = {
          type = "sqlite3";
          uri = "/var/lib/mautrix-whatsapp/mautrix-whatsapp.db";
        };
  encryption = {
    allow = true;
    default = true;
    pickle_key = "pickle_key_ol";
    #require = true;
  };
  homeserver = {
    address = "http://localhost:8008";
    domain = "krinitsin.com";
  };
  matrix = {
    message_status_events = true;
  };
  provisioning = {
    shared_secret = "disable";
  };

    };
  };

}
