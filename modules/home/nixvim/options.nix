{ ... }:

{
  programs.nixvim = {
    globals.mapleader = " ";

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;
      expandtab = true;
      smartindent = true;
      termguicolors = true;
      scrolloff = 8;
      sidescrolloff = 8;
      mouse = "a";
      clipboard = "unnamedplus";
      wrap = false;
      ignorecase = true;
      smartcase = true;
      cursorline = true;
      splitright = true;
      splitbelow = true;
      swapfile = false;
      backup = false;
      undofile = true;
      updatetime = 250;
      signcolumn = "yes";
    };
  };
}
