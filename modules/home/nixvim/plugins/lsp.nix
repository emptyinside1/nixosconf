{ ... }:

{
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      servers = {
        nixd.enable = true;
        pyright.enable = true;
        bashls.enable = true;
        ts_ls.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };
        marksman.enable = true;
        lua_ls.enable = true;
        clangd.enable = true;
        gopls.enable = true;
        jsonls.enable = true;
        yamlls.enable = true;
        html.enable = true;
        cssls.enable = true;
      };
      keymaps = {
        silent = true;
        lspBuf = {
          gd = "definition";
          gr = "references";
          K = "hover";
          "<Space>ca" = "code_action";
          "<Space>cr" = "rename";
        };
      };
    };

    lsp-lines.enable = true;
    fidget.enable = true;

    conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lsp_fallback = "fallback";
          timeout_ms = 1000;
        };
        formatters_by_ft = {
          nix = [ "nixpkgs_fmt" ];
          sh = [ "shfmt" ];
          bash = [ "shfmt" ];
          javascript = [ "prettier" ];
          typescript = [ "prettier" ];
          javascriptreact = [ "prettier" ];
          typescriptreact = [ "prettier" ];
          json = [ "prettier" ];
          yaml = [ "prettier" ];
          markdown = [ "prettier" ];
          python = [ "ruff_format" "black" ];
        };
      };
    };
  };
}
