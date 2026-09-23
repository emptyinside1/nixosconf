{ inputs, config, pkgs, pkgs-stable, ... }:

{
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
      nixclear = "$HOME/.local/bin/nix-cleanall";

      # Быстрые команды
      ccat = "bat";
      grep = "grep --color=auto";
      diff = "diff --color=auto";
        
      # Git shortcuts
      g = "git";
      ga = "git add";
      gc = "git commit -m";
      gp = "git push";
      gs = "git status";
      gd = "git diff"; 

      # Custom shortcut
      obs2pdf = "nix-shell -p python3 python3Packages.markdown2 python3Packages.weasyprint --run \"python3 ${config.home.homeDirectory}/Documents/code/py/Obs/obsidian_to_pdf.py ${config.home.homeDirectory}/Documents/Obs ${config.home.homeDirectory}/Documents/Obs/obsidian_full_book.pdf\"";
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
}
