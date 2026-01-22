{ config, pkgs, pkgs-stable, ... }:

{
  # Версия Home Manager (как stateVersion в NixOS)
  home.stateVersion = "25.11";
  
  home.packages = with pkgs; [
    # Программы GUI.
    telegram-desktop
    steam
    lutris
    protonup-qt
    qbittorrent
    qemu
    winboat
    gearlever
    
    # Терминальные программы.
    zsh
    starship
    oh-my-zsh
    pkgs-stable.htop
    btop
    unimatrix
    fastfetch
    zapret

    # Завимимости.
    gcc
    gnumake
    unzip
    ripgrep
    fd
    lazygit
    lua-language-server
    nil 
    nixd
    stylua
    nodePackages.prettier
    tree-sitter
    tmux
    pay-respects
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "web-search"
        "tmux"
        "extract"
        "thefuck"
        "sudo"
        "copypath"
      ];
      theme = "agnoster";  # будет переопределён starship
    };
    
    shellAliases = {
      ll = "ls -laFh";
      la = "ls -lah";
      ls = "ls -hF --color=auto";
      
      # NixOS specific
      nrd = "sudo nixos-rebuild dry-activate --flake .";
      nrs = "sudo nixos-rebuild switch --flake .";
      nru = "nix flake update";
      ncg = "nix-collect-garbage -d";
      
      # Быстрые команды
      cat = "bat";
      grep = "grep --color=auto";
      diff = "diff --color=auto";
        
      # Git shortcuts
      g = "git";
      ga = "git add";
      gc = "git commit -m";
      gp = "git push";
      gs = "git status";
      gd = "git diff";  
    };
    
    sessionVariables = {
      HISTFILE = "$HOME/.config/zsh/.zsh_history";
      HISTSIZE = "50000";
      SAVEHIST = "50000";
  
    };
    
    initContent = ''
      # Включаем Starship prompt
      eval "$(${pkgs.starship}/bin/starship init zsh)"
      
      # Vi-mode для zsh
      bindkey -v
      bindkey '^R' history-incremental-search-backward
      bindkey '^S' history-incremental-search-forward
      
      # Функции
      mkcd() {
        mkdir -p "$1" && cd "$1"
      }
      
      # Быстрый переход в nixos конфиг
      nix-edit() {
        cd ~/nixos && $EDITOR flake.nix
      }
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      hostname = {
        ssh_only = false;
        format = "[$ssh_symbol$hostname]($style) ";
        # style = "white";
      };
      character = {
        success_symbol = "[ ➜ ](bold green)";
        error_symbol = "[ ➜ ](bold red)";
      };
      username = {
        show_always = true;
        format = "[$user]($style)@";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      git_branch.symbol = " ";
      nix_shell.symbol = "❄️ ";
    };
  }; 
  
  # Базовая настройка git (если ещё не настроено)
  programs.git = {
    enable = true;
  
    # Новый синтаксис (вместо userName/userEmail)
    settings = {
      user = {
        name = "emptyinside1";
        email = "morevdaniil162@gmail.com";
      };
      core.editor = "nvim";
      pull.rebase = true;
      init.defaultBranch = "main";
  

      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        amend = "commit --amend --no-edit";
      };
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Плагины через home-manager
    plugins = with pkgs.vimPlugins; [
      vim-nix                # подсветка синтаксиса Nix
      vim-commentary         # быстрые комментарии
      vim-surround           # редактирование скобок
    ];

    # Инит конфиг
    extraConfig = ''
      set number
      set relativenumber
      set expandtab
      set tabstop=2
      set shiftwidth=2
      set smartindent
      
      " Color scheme
      set background=dark
      
      " Keybindings
      let mapleader = " "
      nnoremap <Leader>w :w<CR>
      nnoremap <Leader>q :q<CR>
    '';
  };

   # ===== XDG КОНФИГУРАЦИЯ (для dotfiles) =====
     /*
    # Конфиг может создавать нередактируемый извне файл прямо тут. 
    xdg.configFile = {
    # Пример: если у тебя есть свой конфиг fastfetch
    "fastfetch/config.jsonc".text = ''
      {
        "logo": "nixos_small",
        "display": {
          "separator": "  "
        }
      }
    '';

    # Пример: конфиг для другой программы
    "ripgrep/.ripgreprc".text = ''
      --max-columns=150
      --max-columns-preview
      --glob=!.git/
    '';
    };

    # Или же конфиг может ссылаться на уже существующий файл.
    xdg.configFiles = {
      "hypr/hyprland.conf".source = ./dotfiles/hyprland.conf
    };
    
    # И также может ссылаться на папку файлов.
    xdg.configFile = {
      "nvim" = {
        source = ./dotfiles/nvim;
        recursive = true;
      };
    };


  */

  # ===== HOME.PACKAGES (альтернатива для конфиг файлов) =====
  home.file = {
    # Кастомные shell скрипты
    ".local/bin/nix-search" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        # Быстрый поиск пакетов в nixpkgs
        query="$1"
        nix search nixpkgs "$query" --json | jq 'keys[]'
      '';
    };

    ".local/bin/nix-cleanup" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        echo "🧹 Очищаю nix store..."
        nix-collect-garbage -d
        echo "✅ Готово!"
      '';
    };

    # Пример конфига если нужно копировать целый файл
    # ".config/my-app/config" = {
    #   source = ./dotfiles/my-app-config;
    # };
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
  ];


}
