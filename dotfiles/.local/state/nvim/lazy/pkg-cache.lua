return {version=12,pkgs={{name="noice.nvim",source="lazy",spec=function()
return {
  -- nui.nvim can be lazy loaded
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "folke/noice.nvim",
  },
}

end,file="lazy.lua",dir="/home/daniil/.local/share/nvim/lazy/noice.nvim",},{name="plenary.nvim",source="lazy",spec={"nvim-lua/plenary.nvim",lazy=true,},file="community",dir="/home/daniil/.local/share/nvim/lazy/plenary.nvim",},},}