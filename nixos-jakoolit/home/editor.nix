{ inputs, config, pkgs, pkgs-stable, ... }:

{
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
}
