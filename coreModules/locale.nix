{ flakeRoot, ... }:
{
  time.timeZone = flakeRoot.timezone;

  i18n.defaultLocale = flakeRoot.locale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = flakeRoot.locale;
    LC_IDENTIFICATION = flakeRoot.locale;
    LC_MEASUREMENT = flakeRoot.locale;
    LC_MONETARY = flakeRoot.locale;
    LC_NAME = flakeRoot.locale;
    LC_NUMERIC = flakeRoot.locale;
    LC_PAPER = flakeRoot.locale;
    LC_TELEPHONE = flakeRoot.locale;
    LC_TIME = flakeRoot.locale;
  };
}
