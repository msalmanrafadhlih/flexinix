{
  programs.bash = {
    enable = true;
  	initExtra = ''
      PROMPT_COMMAND='PS1_CMD1=''$(git branch --show-current 2>/dev/null)'; 
      PS1='\[\e[92m\]\u\[\e[0m\] \[\e[38;5;244;2;5m\]\s\[\e[0m\]in \[\e[93m\]\w\[\e[0m\] \$ ~ \[\e[91m\]''${PS1_CMD1}\n\[\e[0m\]'

      if [ -z "$TMUX" ]; then
          sessions=''$(tmux list-sessions 2>/dev/null | wc -l)

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
      
      #eval "$(tv init bash)"
      export HISTSIZE=5000
      export HISTFILESIZE=10000
      export HISTCONTROL=ignoredups:erasedups
      export PATH="$HOME/.local/bin:$PATH"
      shopt -s histappend
      shopt -s autocd
      shopt -s cdspell
      shopt -s nocaseglob
  	'';
  };
}
