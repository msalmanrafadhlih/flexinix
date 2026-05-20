{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  inp = inputs.racooonfig.inputs;
in

{
  programs.fish = {
    enable = true;
    interactiveShellInit = lib.strings.concatStrings (
      lib.strings.intersperse "\n" [
        "source ${inp.theme-bobthefish}/functions/fish_prompt.fish"
        "source ${inp.theme-bobthefish}/functions/fish_right_prompt.fish"
        "source ${inp.theme-bobthefish}/functions/fish_title.fish"
        (builtins.readFile ./config.fish)
        "set -g SHELL ${pkgs.fish}/bin/fish"
      ]
    );

    plugins =
      map
        (n: {
          name = n;
          src = inp.${n};
        })
        [
          "fish-fzf"
          "fish-foreign-env"
          "theme-bobthefish"
        ];
  };
}
