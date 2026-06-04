{ flakeRoot, ... }:
{
  time.timeZone = flakeRoot.timezone;

  i18n.defaultLocale = flakeRoot.locale;

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "id_ID.UTF-8/UTF-8"
    "C.UTF-8/UTF-8"
  ];

  i18n.extraLocaleSettings = {
    LANG              = flakeRoot.locale;
    LC_CTYPE          = flakeRoot.locale;
    LC_NUMERIC        = flakeRoot.locale;
    LC_TIME           = flakeRoot.locale;
    LC_COLLATE        = flakeRoot.locale;
    LC_MONETARY       = flakeRoot.locale;
    LC_MESSAGES       = flakeRoot.locale;  
    LC_PAPER          = flakeRoot.locale;
    LC_NAME           = flakeRoot.locale;
    LC_ADDRESS        = flakeRoot.locale;
    LC_TELEPHONE      = flakeRoot.locale;
    LC_MEASUREMENT    = flakeRoot.locale;
    LC_IDENTIFICATION = flakeRoot.locale;
  };
}
