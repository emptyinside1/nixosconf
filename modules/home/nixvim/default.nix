{ ... }:

{
  imports = [
    ./options.nix
    ./keymaps.nix
    ./plugins/treesitter.nix
    ./plugins/lsp.nix
    ./plugins/completion.nix
    ./plugins/telescope.nix
    ./plugins/ui.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    nixpkgs.useGlobalPackages = true;
    wrapRc = true;
  };
}
