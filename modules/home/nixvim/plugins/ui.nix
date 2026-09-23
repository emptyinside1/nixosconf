{ ... }:

{
  programs.nixvim = {
    colorschemes.base16 = {
      enable = true;
      colorscheme = "grayscale-dark";
    };

    # Ensure complete transparency across all UI elements and strictly monochrome palette matching Wallust/Kitty
    highlightOverride = {
      Normal = { bg = "none"; ctermbg = "none"; fg = "#FAFAFA"; ctermfg = 15; };
      NormalFloat = { bg = "none"; ctermbg = "none"; fg = "#FAFAFA"; ctermfg = 15; };
      FloatBorder = { bg = "none"; ctermbg = "none"; fg = "#7C7C7C"; ctermfg = 8; };
      SignColumn = { bg = "none"; ctermbg = "none"; };
      LineNr = { bg = "none"; ctermbg = "none"; fg = "#5D5D5D"; ctermfg = 8; };
      CursorLineNr = { bg = "none"; ctermbg = "none"; fg = "#FAFAFA"; ctermfg = 15; bold = true; };
      StatusLine = { bg = "none"; ctermbg = "none"; fg = "#FAFAFA"; ctermfg = 15; };
      StatusLineNC = { bg = "none"; ctermbg = "none"; fg = "#5D5D5D"; ctermfg = 8; };
      EndOfBuffer = { bg = "none"; ctermbg = "none"; fg = "#202020"; ctermfg = 0; };
      TabLine = { bg = "none"; ctermbg = "none"; fg = "#5D5D5D"; ctermfg = 8; };
      TabLineFill = { bg = "none"; ctermbg = "none"; };
      TabLineSel = { bg = "none"; ctermbg = "none"; fg = "#FAFAFA"; ctermfg = 15; bold = true; };
      Pmenu = { bg = "none"; ctermbg = "none"; fg = "#FAFAFA"; ctermfg = 15; };
      PmenuSel = { bg = "#232323"; ctermbg = 0; fg = "#FAFAFA"; ctermfg = 15; bold = true; };

      # Syntax & Treesitter: strict monochrome / grayscale overrides
      Comment = { fg = "#747474"; ctermfg = 8; italic = true; };
      Constant = { fg = "#B4B4B4"; ctermfg = 7; };
      String = { fg = "#B4B4B4"; ctermfg = 7; };
      Character = { fg = "#B4B4B4"; ctermfg = 7; };
      Number = { fg = "#B4B4B4"; ctermfg = 7; };
      Boolean = { fg = "#FAFAFA"; ctermfg = 15; bold = true; };
      Identifier = { fg = "#EFEFEF"; ctermfg = 7; };
      Function = { fg = "#FAFAFA"; ctermfg = 15; bold = true; };
      Statement = { fg = "#B4B4B4"; ctermfg = 7; };
      Keyword = { fg = "#B4B4B4"; ctermfg = 7; bold = true; };
      Type = { fg = "#FAFAFA"; ctermfg = 15; };
      Special = { fg = "#B4B4B4"; ctermfg = 7; };
      Directory = { fg = "#FAFAFA"; ctermfg = 15; bold = true; };

      "@variable" = { fg = "#EFEFEF"; ctermfg = 7; };
      "@function" = { fg = "#FAFAFA"; ctermfg = 15; bold = true; };
      "@keyword" = { fg = "#B4B4B4"; ctermfg = 7; bold = true; };
      "@type" = { fg = "#FAFAFA"; ctermfg = 15; };
      "@string" = { fg = "#B4B4B4"; ctermfg = 7; };
      "@comment" = { fg = "#747474"; ctermfg = 8; italic = true; };
      "@constant" = { fg = "#B4B4B4"; ctermfg = 7; };
      "@property" = { fg = "#EFEFEF"; ctermfg = 7; };

      # Telescope & Bufferline
      TelescopeBorder = { bg = "none"; ctermbg = "none"; fg = "#7C7C7C"; ctermfg = 8; };
      TelescopeSelection = { bg = "#232323"; ctermbg = 0; fg = "#FAFAFA"; ctermfg = 15; };
      BufferLineFill = { bg = "none"; ctermbg = "none"; };
      BufferLineBackground = { bg = "none"; ctermbg = "none"; fg = "#7C7C7C"; };
      BufferLineSelected = { bg = "none"; ctermbg = "none"; fg = "#FAFAFA"; ctermfg = 15; bold = true; };
    };

    plugins = {
      which-key.enable = true;

      oil = {
        enable = true;
        settings = {
          default_file_explorer = true;
          view_options = {
            show_hidden = true;
          };
        };
      };

      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "auto";
            icons_enabled = true;
            component_separators = { left = "|"; right = "|"; };
            section_separators = { left = ""; right = ""; };
          };
        };
      };

      bufferline = {
        enable = true;
        settings = {
          options = {
            diagnostics = "nvim_lsp";
            show_buffer_close_icons = false;
            show_close_icon = false;
          };
        };
      };

      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add.text = "+";
            change.text = "~";
            delete.text = "_";
            topdelete.text = "‾";
            changedelete.text = "~";
          };
        };
      };

      mini = {
        enable = true;
        modules = {
          pairs = {};
          comment = {};
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<Space>gg";
        action = "<cmd>Gitsigns preview_hunk<CR>";
        options = {
          desc = "Preview git hunk";
          silent = true;
        };
      }
    ];
  };
}
