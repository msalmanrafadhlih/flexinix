{ pkgs, ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    initExtra = ''
      # hanya untuk interactive shell
      [[ $- != *i* ]] && return

      # ==========================================================
      # ENV & HISTORY
      # ==========================================================
      export HISTSIZE=5000
      export HISTFILESIZE=10000
      export HISTCONTROL=ignoredups:erasedups
      export PATH="$HOME/.local/bin:$PATH"
      # eval "$(tv init bash)"

      shopt -s histappend
      shopt -s autocd
      shopt -s cdspell
      shopt -s nocaseglob

      # ==========================================================
      # TMUX AUTO START
      # ==========================================================
      if [ -z "$TMUX" ]; then
        sessions=$(tmux list-sessions 2>/dev/null | wc -l)

        if [ "$sessions" -eq 0 ]; then
          tmux new-session
        else
          tmux attach-session \; choose-session
        fi
      fi

      # # ==========================================================
      # # Auto Zellij (Cara Singkat)
      # # ==========================================================
      # if [[ -z "$ZELLIJ" ]]; then
      #     zellij attach -c
      # fi

      # ==========================================================
      # LOAD BLE.SH (autosuggest + syntax highlight)
      # ==========================================================
      source ${pkgs.blesh}/share/blesh/ble.sh

      # --- BLE CONFIG ---
      bleopt complete_auto_history=1
      bleopt complete_auto_complete=1
      bleopt complete_auto_delay=200

      # bleopt prompt_ps1_final='yes'
      # bleopt exec_errexit_mark='[ERR]'

      # ==========================================================
      # CUSTOM PROMPT (AMAN UNTUK BLE.SH)
      # ==========================================================
      __prompt_git_branch() {
        git branch --show-current 2>/dev/null
      }

      PS1='\[\e[92m\]\u\[\e[0m\] \[\e[38;5;244m\]\s\[\e[0m\] in \[\e[93m\]\w\[\e[0m\] \$ ~ \[\e[91m\]$(__prompt_git_branch)\[\e[0m\]\n> '
    '';
  };

  home.packages = with pkgs; [
    bash-completion
    blesh
  ];
}
