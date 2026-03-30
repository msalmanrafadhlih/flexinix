# ./aliases.nix
{ ... }: {

  ## Tmux
  TMUXSAVE = "tmux source-file ~/.config/tmux/tmux.conf";
  TMUXDEL = "tmux kill-server";
  MOSH = "mosh --ssh='ssh -p 8022'";

  # Python
  py = "python3";
  PY-SERVER = "python3 -m http.server";

  # Others
  CLEAR = "clear";
  clar = "clear";
  CLS = "clear";
  cls = "clear";
  C = "clear";
  c = "clear";

}
