{ ... }:

{
  programs.nixvim.keymaps = [
    # General / File operations
    {
      mode = "n";
      key = "<Space>w";
      action = "<cmd>w<CR>";
      options = {
        desc = "Save buffer";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<Space>q";
      action = "<cmd>q<CR>";
      options = {
        desc = "Quit window";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<Space>bd";
      action = "<cmd>bdelete<CR>";
      options = {
        desc = "Close current buffer";
        silent = true;
      };
    }

    # Buffer navigation
    {
      mode = "n";
      key = "<Tab>";
      action = "<cmd>bnext<CR>";
      options = {
        desc = "Next buffer";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<S-Tab>";
      action = "<cmd>bprevious<CR>";
      options = {
        desc = "Previous buffer";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "]b";
      action = "<cmd>bnext<CR>";
      options = {
        desc = "Next buffer";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "[b";
      action = "<cmd>bprevious<CR>";
      options = {
        desc = "Previous buffer";
        silent = true;
      };
    }

    # Telescope
    {
      mode = "n";
      key = "<Space>ff";
      action = "<cmd>Telescope find_files<CR>";
      options = {
        desc = "Telescope find files";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<Space>fg";
      action = "<cmd>Telescope live_grep<CR>";
      options = {
        desc = "Telescope live grep";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<Space>fb";
      action = "<cmd>Telescope buffers<CR>";
      options = {
        desc = "Telescope buffers";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<Space>fh";
      action = "<cmd>Telescope help_tags<CR>";
      options = {
        desc = "Telescope help tags";
        silent = true;
      };
    }

    # Oil file manager
    {
      mode = "n";
      key = "-";
      action = "<cmd>Oil<CR>";
      options = {
        desc = "Open Oil file manager";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<Space>e";
      action = "<cmd>Oil<CR>";
      options = {
        desc = "Open Oil file manager";
        silent = true;
      };
    }

    # Diagnostics
    {
      mode = "n";
      key = "[d";
      action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
      options = {
        desc = "Previous diagnostic";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "]d";
      action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
      options = {
        desc = "Next diagnostic";
        silent = true;
      };
    }
  ];
}
