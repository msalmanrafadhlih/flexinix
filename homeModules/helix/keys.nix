{
  # --- INSERT MODE ---
  insert = {
    # Keybinding "Mash" untuk keluar ke normal mode dengan cepat (f+j atau j+f)
    k = { j = "normal_mode"; };
    j = { k = "normal_mode"; };
    J = { K = "normal_mode"; };
    K = { J = "normal_mode"; };
    
    # Completion trigger manual
    "C-space" = "completion";
  };

  # --- NORMAL MODE ---
  normal = {
    # Navigasi dasar & Buffer
    esc = [ "collapse_selection" "keep_primary_selection" ];
    "{" = "goto_prev_paragraph";
    "}" = "goto_next_paragraph";

    # Integrasi Yazi Picker (Ctrl + y)
    "C-p" = {
      y = ":sh zellij run -n \"\" -c -f -x 10% -y 10% --width 80% --height 80% -- yazi-picker open %{buffer_name}";
      v = ":sh zellij run -n \"\" -c -f -x 10% -y 10% --width 80% --height 80% -- yazi-picker vsplit %{buffer_name}";
      h = ":sh zellij run -n \"\" -c -f -x 10% -y 10% --width 80% --height 80% -- yazi-picker hsplit %{buffer_name}";
      p = ":sh fuser -k 6419/tcp 2>/dev/null; go-grip $(pwd)";
    };

    # Shortcut Select All (m + w)
    m = { w = "select_all"; };

    # --- SPACE MENU ---
    space = {
      # File management standar
      w = ":write";
      q = ":quit";
      x = ":buffer-close"; # Tambahan dari TOML
      
      # Text case transformation
      u = "switch_to_lowercase";
      U = "switch_to_uppercase";

      # 1. File Picker via Yazi (Space + Space)
      space = [
        ":sh zellij run -n \"\" -c -f -x 10% -y 10% --width 80% --height 80% -- yazi-picker open %{buffer_name}"
        ":redraw"
      ];

      # 2. Git via Lazygit (Space + g)
      g = [
        ":sh zellij action new-pane --name \"\" --floating --width 80% --height 80% --x 10% --y 10% --close-on-exit -- lazygit"
        ":redraw"
      ];

      # 3. Search & Replace via Serpl (Space + ;)
      ";" = [
        ":sh zellij action new-pane --name \"\" --floating --width 80% --height 80% --x 10% --y 10% --close-on-exit -- serpl"
      ];

      # 4. LLM / AI Integration (Space + l)
      # Note: Menggunakan script kustom 'gemini', 'llm-gen-commit-msg', dll.
      l = {
        c = [ ":sh zellij action new-pane --name \"\"  --floating --width 35% --height 96% --x 70% --y 2% --close-on-exit -- gemini" ];
        m = [ ":sh zellij action new-pane --name \"\"  --floating --width 35% --height 96% --x 70% --y 2% --close-on-exit -- llm-gen-commit-msg" ];
        e = [ ":sh zellij action new-pane --name \"\"  --floating --width 35% --height 96% --x 70% --y 2% --close-on-exit -- llm-explain" ];
        a = [ ":sh zellij action new-pane --name \"\"  --floating --width 35% --height 96% --x 70% --y 2% --close-on-exit -- llm-do-anal" ];
      };

      # 5. Line Numbers (Space + n)
      # DIPINDAHKAN dari 'space.l' karena konflik dengan LLM
      n = {
        a = ":set line-number absolute";
        r = ":set line-number relative";
        n = ":set line-number none";
      };

      # 6. Toggles (Space + t)
      t = {
        s = ":toggle-option soft-wrap.enable";
        u = "switch_case";
      };
    };
  };

  # --- SELECT MODE ---
  select = {
    "{" = "goto_prev_paragraph";
    "}" = "goto_next_paragraph";
    m = { w = "select_all"; };
    
    space = {
      u = "switch_to_lowercase";
      U = "switch_to_uppercase";
      t = {
        s = ":toggle-option soft-wrap.enable";
        u = "switch_case";
      };
    };
  };
}
