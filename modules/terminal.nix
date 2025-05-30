# Terminal and shell configuration - Ultra Dark Japanese Theme
{ config, pkgs, ... }:
{
  # Fish shell configuration
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "eza -la --icons";
      la = "eza -la --icons";
      ls = "eza --icons";
      tree = "eza --tree --icons";
      cat = "bat";
      find = "fd";
      grep = "rg";
      sync = "~/wlmrNix/sync.sh";
      # Japanese-inspired aliases
      kaku = "code"; # 書く (to write)
      miru = "bat"; # 見る (to see/look)
      sagasu = "fd"; # 探す (to search)
    };
    shellInit = ''
      # Set Japanese locale support
      set -x LC_ALL en_US.UTF-8
      set -x LANG en_US.UTF-8
      
      # Ultra minimal fish greeting
      set -g fish_greeting ""
    '';
  };

  # Alacritty terminal - Ultra Dark Japanese Theme
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "xterm-256color";
      };
      window = {
        padding = { x = 20; y = 12; };
        opacity = 0.92;
        blur = true;
        decorations = "buttonless"; # Clean, minimal window
        startup_mode = "Windowed";
        title = "端末"; # "Terminal" in Japanese
      };
      scrolling = {
        history = 50000;
        multiplier = 3;
      };
      font = {
        normal = {
          family = "JetBrains Mono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrains Mono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrains Mono Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "JetBrains Mono Nerd Font";
          style = "Bold Italic";
        };
        size = 11;
        offset = { x = 0; y = 1; }; # Slight vertical adjustment for better readability
      };

      # TokyoNight Color Scheme with Pure Black Background
      colors = {
        primary = {
          background = "0x000000"; # Pure black background
          foreground = "0xc0caf5"; # TokyoNight foreground
          dim_foreground = "0xa9b1d6"; # TokyoNight dim foreground
        };
        cursor = {
          text = "0x000000";
          cursor = "0xc0caf5"; # TokyoNight cursor
        };
        vi_mode_cursor = {
          text = "0x000000";
          cursor = "0x7aa2f7"; # TokyoNight blue
        };
        selection = {
          text = "0xc0caf5";
          background = "0x33467c"; # TokyoNight selection
        };

        # Search colors
        search = {
          matches = {
            foreground = "0x000000";
            background = "0xff9e64"; # TokyoNight orange
          };
          focused_match = {
            foreground = "0x000000";
            background = "0xe0af68"; # TokyoNight yellow
          };
        };

        # Normal colors - Official TokyoNight palette
        normal = {
          black = "0x15161e"; # TokyoNight black
          red = "0xf7768e"; # TokyoNight red
          green = "0x9ece6a"; # TokyoNight green
          yellow = "0xe0af68"; # TokyoNight yellow
          blue = "0x7aa2f7"; # TokyoNight blue
          magenta = "0xbb9af7"; # TokyoNight purple
          cyan = "0x7dcfff"; # TokyoNight cyan
          white = "0xa9b1d6"; # TokyoNight white
        };

        # Bright colors - TokyoNight bright variants
        bright = {
          black = "0x414868"; # TokyoNight bright black
          red = "0xf7768e"; # TokyoNight bright red
          green = "0x9ece6a"; # TokyoNight bright green
          yellow = "0xe0af68"; # TokyoNight bright yellow
          blue = "0x7aa2f7"; # TokyoNight bright blue
          magenta = "0xbb9af7"; # TokyoNight bright purple
          cyan = "0x7dcfff"; # TokyoNight bright cyan
          white = "0xc0caf5"; # TokyoNight bright white
        };

        # Dim colors - TokyoNight dimmed variants
        dim = {
          black = "0x15161e";
          red = "0xe06c75";
          green = "0x73c991";
          yellow = "0xd19a66";
          blue = "0x61afef";
          magenta = "0xc678dd";
          cyan = "0x56b6c2";
          white = "0x828bb8";
        };
      };

      bell = {
        animation = "EaseOutExpo";
        duration = 100; # Quick, subtle
        color = "0xff6b6b";
      };

      # Minimal key bindings - Japanese philosophy of simplicity
      keyboard.bindings = [
        { key = "V"; mods = "Control|Shift"; action = "Paste"; }
        { key = "C"; mods = "Control|Shift"; action = "Copy"; }
        { key = "Plus"; mods = "Control"; action = "IncreaseFontSize"; }
        { key = "Minus"; mods = "Control"; action = "DecreaseFontSize"; }
        { key = "Key0"; mods = "Control"; action = "ResetFontSize"; }
      ];
    };
  };

  # Starship prompt - Minimal Japanese aesthetic
  programs.starship = {
    enable = true;
    settings = {
      format = "$directory$git_branch$git_status$character";

      # Ultra minimal character
      character = {
        success_symbol = "[▶](bold red)"; # Simple arrow, red like traditional Japanese
        error_symbol = "[▶](bold dim red)";
        vimcmd_symbol = "[◀](bold blue)";
      };

      # Directory styling
      directory = {
        style = "bold cyan";
        truncation_length = 3;
        truncate_to_repo = true;
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };

      # Git branch styling
      git_branch = {
        symbol = "⋆ "; # Simple star instead of git symbol
        style = "bold purple";
        format = "[$symbol$branch]($style) ";
      };

      # Git status - minimal
      git_status = {
        style = "red";
        format = "[$all_status$ahead_behind]($style)";
        conflicted = "×";
        ahead = "↑";
        behind = "↓";
        diverged = "↕";
        up_to_date = "";
        untracked = "?";
        stashed = "$";
        modified = "!";
        staged = "+";
        renamed = "»";
        deleted = "✘";
      };

      # Disable unused modules for ultra clean look
      aws.disabled = true;
      gcloud.disabled = true;
      kubernetes.disabled = true;
      nodejs.disabled = true;
      python.disabled = true;
      ruby.disabled = true;
      rust.disabled = true;
      java.disabled = true;
      golang.disabled = true;
      package.disabled = true;
      cmd_duration.disabled = true;
      time.disabled = true;
    };
  };

  # Essential CLI tools with Japanese naming awareness
  home.packages = with pkgs; [
    eza # Modern ls replacement
    bat # Cat with syntax highlighting
    ripgrep # Fast grep
    fd # Fast find
    fzf # Fuzzy finder
    zoxide # Smart cd
    tree # Directory tree
    htop # System monitor
    neofetch # System info

    # Japanese font support
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  # Additional fish functions for Japanese-inspired workflow
  programs.fish.functions = {
    # Clean function - inspired by Japanese minimalism
    clean = "clear && echo '清潔' && ls"; # "Clean" in Japanese

    # Quick system info with Japanese header
    info = "echo '情報:' && neofetch"; # "Information" in Japanese

    # Focused work session starter
    focus = ''
      clear
      echo "集中時間" # "Focus time" in Japanese
      echo "────────"
      pwd
      git status 2>/dev/null || echo "No git repository"
    '';
  };
}
