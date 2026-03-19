# ==========================================================
# Interactive guard
# ==========================================================
[[ $- != *i* ]] && return

# ==========================================================
# Auto TMUX (intentional behavior)
# ==========================================================
if [[ -z "$TMUX" ]]; then
    sessions=$(tmux list-sessions 2>/dev/null | wc -l)

    if [[ "$sessions" -eq 0 ]]; then
        tmux new-session
    else
        tmux attach-session \; choose-session
    fi
fi

# eval "$(tv init zsh)"

# ==========================================================
# Completion & compinit cache
# ==========================================================
autoload -Uz compinit
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

local zcompdump="$HOME/.config/zsh/zcompdump-$ZSH_VERSION"

if [[ -n "$zcompdump"(#qN.mh+24) ]]; then
    compinit -i -d "$zcompdump"
else
    compinit -C -d "$zcompdump"
fi

if [[ ! -f "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc" ]]; then
    zcompile -U "$zcompdump"
fi

# ==========================================================
# Environment
# ==========================================================
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
export SUDO_PROMPT="Deploying root access for %u. Password pls: "
export BAT_THEME="base16"
export KEYTIMEOUT=1

if [[ -d "$HOME/.local/bin" ]]; then
    PATH="$HOME/.local/bin:$PATH"
fi

SAVEHIST=2000
HISTSIZE=2000
HISTDUP=erase
HISTFILE="$HOME/.config/zsh/.zsh_history"

# ==========================================================
# Completion styles
# ==========================================================
_comp_options+=(globdots)
precmd_functions+=(vcs_info)

zstyle ':completion:*' menu select
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}' \
    '+r:|[._-]=* r:|=*' \
    '+l:|=*'

zstyle ':vcs_info:*' formats ' %B%s-[%F{magenta}%f %F{yellow}%b%f]-'

zstyle ':fzf-tab:*' fzf-flags \
    --style=full \
    --height=90% \
    --pointer '>' \
    --color 'pointer:green:bold,bg+:-1:,fg+:green:bold,info:blue:bold,marker:yellow:bold,hl:gray:bold,hl+:yellow:bold' \
    --input-label ' Search ' \
    --color 'input-border:blue,input-label:blue:bold' \
    --list-label ' Results ' \
    --color 'list-border:green,list-label:green:bold' \
    --preview-label ' Preview ' \
    --color 'preview-border:magenta,preview-label:magenta:bold'

zstyle ':fzf-tab:complete:cd:*'  fzf-preview 'eza -1 --icons=always --color=always -a $realpath'
zstyle ':fzf-tab:complete:eza:*' fzf-preview 'eza -1 --icons=always --color=always -a $realpath'
zstyle ':fzf-tab:complete:bat:*' fzf-preview 'bat --color=always --theme=base16 $realpath'
zstyle ':fzf-tab:*' fzf-bindings 'space:accept'
zstyle ':fzf-tab:*' accept-line enter

# ==========================================================
# Completion UI helper
# ==========================================================
expand-or-complete-with-dots() {
    echo -n $'\e[31m…\e[0m'
    zle expand-or-complete
    zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey '^I' expand-or-complete-with-dots

# ==========================================================
# Prompt
# ==========================================================

dir_icon() {
    if [[ "$PWD" == "$HOME" ]]; then
        echo "%B%F{cyan} %f%b"
    else
        echo "%B%F{cyan} %f%b"
    fi
}

PS1=$'%B%F{blue} %f%b %B%F{magenta}%n%f%b $(dir_icon) %B%F{yellow}%~%f%b${vcs_info_msg_0_}\n%(?.%B%F{green}.%F{red})%f%b '

# ==========================================================
# Plugins (manual)
# ==========================================================
# source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# source ~/.config/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# ==========================================================
# Keybindings
# ==========================================================
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[3~' delete-char
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# ==========================================================
# Terminal title (xterm / tmux / kitty)
# ==========================================================
xterm_title_precmd() {
    print -Pn -- '\e]2;%n@%m %~\a'
    [[ "$TERM" == screen* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}

xterm_title_preexec() {
    print -Pn -- '\e]2;%n@%m %~ %# '
    print -n -- "${(q)1}\a"

    [[ "$TERM" == screen* ]] && {
        print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# '
        print -n -- "${(q)1}\e\\"
    }
}

if [[ "$TERM" == (kitty*|alacritty*|tmux*|screen*|xterm*) ]]; then
    add-zsh-hook precmd  xterm_title_precmd
    add-zsh-hook preexec xterm_title_preexec
fi

# ==========================================================
# yt-dlp helpers
# ==========================================================
DMUSIC() {
    local url="$1"
    [[ -z "$url" ]] && { echo 'Usage: DMUSIC "<url>"'; return 1; }

    yt-dlp \
        --no-playlist \
        --extract-audio \
        --audio-format mp3 \
        --audio-quality 0 \
        --embed-thumbnail \
        --embed-metadata \
        --parse-metadata 'playlist_index:%(track_number)s' \
        --format 'ba/best' \
        --retry-sleep 3 \
        --retries infinite \
        --download-archive "$HOME/Musics/downloaded_archive.txt" \
        --output "$HOME/Musics/%(artist)s/%(title)s.%(ext)s" \
        --extractor-args 'youtube:player_client=android' \
        --restrict-filenames \
        --windows-filenames \
        "$url"
}

DVIDEO() {
    local url="$1"
    [[ -z "$url" ]] && { echo 'Usage: DVIDEO "<url>"'; return 1; }

    yt-dlp \
        --no-playlist \
        --format 'bestvideo[height<=720]+bestaudio/best[height<=720]' \
        --embed-thumbnail \
        --embed-metadata \
        --embed-chapters \
        --retry-sleep 3 \
        --retries infinite \
        --merge-output-format mkv \
        --download-archive "$HOME/Videos/downloaded_archive.txt" \
        --output "$HOME/Videos/%(uploader)s/%(title)s [%(id)s].%(ext)s" \
        --extractor-args 'youtube:player_client=android' \
        --restrict-filenames \
        "$url"
}

DPLAYLIST() {
    local url="$1"
    [[ -z "$url" ]] && { echo 'Usage: DPLAYLIST "<url>"'; return 1; }

    yt-dlp \
        --extract-audio \
        --audio-format mp3 \
        --audio-quality 0 \
        --embed-thumbnail \
        --embed-metadata \
        --yes-playlist \
        --ignore-errors \
        --format 'ba/best' \
        --retry-sleep 3 \
        --retries infinite \
        --download-archive "$HOME/Musics/downloaded_archive.txt" \
        --output "$HOME/Musics/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" \
        --extractor-args 'youtube:player_client=android' \
        "$url"
}


tmux_fzf() {
  local input="$1"
  local prompt="$2"

  tmux display-popup -E "$SHELL -ic 'printf \"$input\" | fzf --prompt=\"$prompt\" | tmux load-buffer -b pickbuf -'"
  local result=$(tmux save-buffer -b pickbuf -)
  tmux delete-buffer -b pickbuf

  echo "$result"
}

SAVEFLAKE() {
  local dir="$HOME/.dotfiles/$XDG_CURRENT_DESKTOP"
  local timestamp=$(date "+%Y-%m-%d %H:%M")
  
  local sys_msg="${1:-"Update via SAVEFLAKE"}"
  local current_branch=$(git branch --show-current)
  local target_branch="${2:-$current_branch}"

  cd "$dir" || { echo "❌ Directory $dir tidak ditemukan!"; return 1 }

  echo "🚀 Memproses dotfiles di $dir..."
  if [[ -n $(git status --porcelain) ]]; then
    git diff --name-only | xargs -I{} sh -c "git add '{}' && git commit -m '$timestamp | $sys_msg: {}'"
    git add .
    git commit -m "$timestamp | $sys_msg"
    git push origin "$target_branch"
    echo "✅ Changes pushed to $target_branch dengan pesan: $sys_msg"
  else
    echo "⚡ Tidak ada perubahan di $dir."
  fi

  echo -n "\nLanjut rebuild system? (y/n) "
  read -k 1 res
  echo

  if [[ "$res" == "y" ]]; then
    cd "/etc/nixos/system" || { echo "❌ Directory system tidak ditemukan!"; return 1 }

    local host=$(tmux_fzf "infinix\nwsl\nmacbook\nvm-aarch64" "Pilih host (ctrl-c to cancel): ")
    tmux delete-buffer

    [[ -z "$host" ]] && { echo "🛑 Rebuild dibatalkan, host tidak dipilih."; return 1 }

    local spec=$(tmux_fzf "bspwm\nniri\nhyprland" "Specialisation: (ctrl-c to cancel)")
    tmux delete-buffer

    [[ "$spec" == "none" ]] && spec=""
    
    echo "🔄 Updating Nix flake..."
    nix flake update

    if [[ -n $(git status --porcelain) ]]; then
      git diff --name-only | xargs -I{} sh -c "git add '{}' && git commit -m '$timestamp | $sys_msg: {}'"
      git add .
      git commit -m "$timestamp | Rebuild system ($host): $sys_msg"
    fi

    echo "🚀 Rebuilding NixOS untuk $host..."
    if [[ -z "$spec" ]]; then
      sudo nixos-rebuild switch --flake .#"$host"
    else
      sudo nixos-rebuild switch --flake .#"$host" --specialisation "$spec"
    fi

    echo "✅ System rebuild selesai!"
  else
    echo "🛑 Rebuild dibatalkan."
  fi
}

SAVECLEAN() {
    echo "🧹 Memulai pembersihan sistem yang aman (Safe Mode)..."

    # 1. NixOS: Membersihkan Store tapi menyisakan 7 hari terakhir
    # Sangat aman: Memastikan kamu tetap punya fallback jika butuh rollback,
    # dan mencegah CPU kerja terlalu keras saat rebuild environment.
    if command -v nix-env &> /dev/null; then
        echo "-> Membersihkan Nix Store (menyisakan 7 hari terakhir)..."
        nix-collect-garbage --delete-older-than 7d
        sudo nix-collect-garbage --delete-older-than 7d
    fi

    # 2. Log Systemd: Dibatasi ukuran dan umurnya
    if command -v journalctl &> /dev/null; then
        echo "-> Membersihkan log systemd (Maks 100MB atau 7 hari)..."
        sudo journalctl --vacuum-time=7d
        sudo journalctl --vacuum-size=100M
    fi

    # 3. Cache Aplikasi Desktop (Aman dihapus kapan saja)
    echo "-> Membersihkan cache Thumbnails gambar..."
    rm -rf ~/.cache/thumbnails/*

    # Membersihkan cache browser Vivaldi tanpa menyentuh session/history
    if [ -d "$HOME/.cache/vivaldi" ]; then
        echo "-> Membersihkan cache browser Vivaldi..."
        rm -rf ~/.cache/vivaldi/Default/Cache/Cache_Data/*
        rm -rf ~/.cache/vivaldi/Default/System\ Cache/*
    fi

    # 4. Cache Development (Biasanya ini yang bikin disk cepat penuh)
    echo "-> Membersihkan cache environment programming..."
    
    # JavaScript / Node.js
    if command -v npm &> /dev/null; then
        echo "   - Membersihkan NPM cache..."
        npm cache clean --force
    fi
    
    # Rust (Cargo menyimpan banyak file tarball di registry)
    if [ -d "$HOME/.cargo/registry/cache" ]; then
        echo "   - Membersihkan Cargo registry cache..."
        rm -rf ~/.cargo/registry/cache/*
    fi

    # npm
    if [ -d "$HOME/.npm/_cacache" ]; then
        echo "   - Membersihkan npm registry cache..."
        rm -rf ~/.npm/_cacache 2>/dev/null
    fi

    # Java (Gradle caches bisa membengkak sangat besar)
    if [ -d "$HOME/.gradle/caches" ]; then
        echo "   - Membersihkan Gradle cache..."
        rm -rf ~/.gradle/caches/*
    fi

    # 5. Mengosongkan Trash
    echo "-> Mengosongkan Trash..."
    rm -rf ~/.local/share/Trash/files/*
    rm -rf ~/.local/share/Trash/info/*

    echo "✨ Pembersihan aman selesai! Ruang penyimpanan lega tanpa risiko aplikasi crash."
}
