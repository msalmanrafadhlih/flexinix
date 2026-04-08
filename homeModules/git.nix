{ ... }:

{
  programs.git = {
    enable = true;
    # signing = {
    #   key = "523D5DC389D273BC";
    #   signByDefault = true;
    # };
    settings = {
      user.name = "msalmanrafadhlih";
      user.email = "141149698+msalmanrafadhlih@users.noreply.github.com";
      branch.autosetuprebase = "always";
      color.ui = true;
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      credential.helper = "store"; # want to make this more secure
      github.user = "msalmanafadhlih";
      push.default = "tracking";
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      aliases = {
        cleanup = "!git branch --merged | grep  -v '\\*\\|master\\|develop' | xargs -n 1 -r git branch -d";
        prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        root = "rev-parse --show-toplevel";
        GRAPH = "git log --oneline --decorate --graph --all";
        GIT = "git add . && git commit -m";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true; # Ini default-nya true, dia yang akan set core.pager
    options = {
      line-numbers = true;
      side-by-side = true;
    };
  };
}
