local lazypath = "/nvim_path_to_replace/plugins/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Lazy needs for the leader to set before loading plugins so to not mess up key mappings.
vim.g.mapleader = ';'
vim.g.maplocalleader = ';'

require("lazy").setup({
  {
    'isakbm/gitgraph.nvim',
	  dir = "/nvim_path_to_replace/plugins/gitgraph",
    opts = {
      symbols = {
        merge_commit = 'M',
        commit = '*',
      },
      format = {
        timestamp = '%H:%M:%S %d-%m-%Y',
        fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
      },
      hooks = {
        -- Check diff of a commit
        on_select_commit = function(commit)
          vim.notify('DiffviewOpen ' .. commit.hash .. '^!')
          vim.cmd(':DiffviewOpen ' .. commit.hash .. '^!')
        end,
        -- Check diff from commit a -> commit b
        on_select_range_commit = function(from, to)
          vim.notify('DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
          vim.cmd(':DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
        end,
      },
    },
    keys = {
      {
        "<leader>gl",
        function()
          require('gitgraph').draw({}, { all = true, max_count = 5000 })
        end,
        desc = "GitGraph - Draw",
      },
    },
  },
  {
    "Isrothy/neominimap.nvim",
    dir = "/nvim_path_to_replace/plugins/neominimap.nvim",
    version = "v3.x.x",
    lazy = false, -- NOTE: NO NEED to Lazy load
    keys = {
      -- Global Minimap Controls
      { "<leader>nm", "<cmd>Neominimap Toggle<cr>", desc = "Toggle global minimap" },
      { "<leader>no", "<cmd>Neominimap Enable<cr>", desc = "Enable global minimap" },
      { "<leader>nc", "<cmd>Neominimap Disable<cr>", desc = "Disable global minimap" },
      { "<leader>nr", "<cmd>Neominimap Refresh<cr>", desc = "Refresh global minimap" },

      -- Window-Specific Minimap Controls
      { "<leader>nwt", "<cmd>Neominimap WinToggle<cr>", desc = "Toggle minimap for current window" },
      { "<leader>nwr", "<cmd>Neominimap WinRefresh<cr>", desc = "Refresh minimap for current window" },
      { "<leader>nwo", "<cmd>Neominimap WinEnable<cr>", desc = "Enable minimap for current window" },
      { "<leader>nwc", "<cmd>Neominimap WinDisable<cr>", desc = "Disable minimap for current window" },

      -- Tab-Specific Minimap Controls
      { "<leader>ntt", "<cmd>Neominimap TabToggle<cr>", desc = "Toggle minimap for current tab" },
      { "<leader>ntr", "<cmd>Neominimap TabRefresh<cr>", desc = "Refresh minimap for current tab" },
      { "<leader>nto", "<cmd>Neominimap TabEnable<cr>", desc = "Enable minimap for current tab" },
      { "<leader>ntc", "<cmd>Neominimap TabDisable<cr>", desc = "Disable minimap for current tab" },

      -- Buffer-Specific Minimap Controls
      { "<leader>nbt", "<cmd>Neominimap BufToggle<cr>", desc = "Toggle minimap for current buffer" },
      { "<leader>nbr", "<cmd>Neominimap BufRefresh<cr>", desc = "Refresh minimap for current buffer" },
      { "<leader>nbo", "<cmd>Neominimap BufEnable<cr>", desc = "Enable minimap for current buffer" },
      { "<leader>nbc", "<cmd>Neominimap BufDisable<cr>", desc = "Disable minimap for current buffer" },

      ---Focus Controls
      { "<leader>nf", "<cmd>Neominimap Focus<cr>", desc = "Focus on minimap" },
      { "<leader>nu", "<cmd>Neominimap Unfocus<cr>", desc = "Unfocus minimap" },
      { "<leader>ns", "<cmd>Neominimap ToggleFocus<cr>", desc = "Switch focus on minimap" },
    },
    init = function()
      -- The following options are recommended when layout == "float"
      vim.opt.wrap = false
      vim.opt.sidescrolloff = 36 -- Set a large value

      --- Put your configuration here
      vim.g.neominimap = {
        auto_enable = true,
      }
    end,
  },
	{
	  "morhetz/gruvbox",
	  priority = 100,
	  dir = "/nvim_path_to_replace/plugins/gruvbox",
	  config = function()
	  vim.cmd([[colorscheme gruvbox]])
  	  end,
	},
	{
	  "neovim/nvim-lspconfig",
	  dir = "/nvim_path_to_replace/plugins/nvim-lspconfig",
	   config = function()
	   end,
	},
  { "hrsh7th/nvim-cmp",
	  dir = "/nvim_path_to_replace/plugins/nvim-cmp",
  },
  { 
    "hrsh7th/cmp-nvim-lsp",
	  dir = "/nvim_path_to_replace/plugins/cmp-nvim-lsp",
  },
  {
    "hrsh7th/cmp-buffer",
	  dir = "/nvim_path_to_replace/plugins/cmp-buffer",
  },
  {
    'nvim-telescope/telescope.nvim',
	  dir = "/nvim_path_to_replace/plugins/telescope.nvim",
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
	{
	  "nvim-lua/plenary.nvim",
	  dir = "/nvim_path_to_replace/plugins/plenary.nvim",
	},
	{
	  "MunifTanjim/nuy.nvim",
	  dir = "/nvim_path_to_replace/plugins/nui.nvim"
	},
	{
	  "nvim-neo-tree/neo-tree.nvim",
	  dir = "/nvim_path_to_replace/plugins/neo-tree.nvim"
	},
	{
	  "tpope/vim-surround",
	  dir = "/nvim_path_to_replace/plugins/vim-surround"
	},
	{
	  "tpope/vim-commentary",
	  dir = "/nvim_path_to_replace/plugins/vim-commentary"
	},
	{
	  "tpope/vim-fugitive",
	  dir = "/nvim_path_to_replace/plugins/vim-fugitive"
	},
	{
	  "tpope/vim-abolish",
	  dir = "/nvim_path_to_replace/plugins/vim-abolish"
	},
	{
	  "RRethy/vim-illuminate",
	  dir = "/nvim_path_to_replace/plugins/vim-illuminate"
	},
	{
	  "sindrets/diffview.nvim",
	  dir = "/nvim_path_to_replace/plugins/diffview.nvim"
	},
	{
	  "simrat39/symbols-outline.nvim",
	  dir = "/nvim_path_to_replace/plugins/symbols-outline.nvim"
	},
	{
	  "tommcdo/vim-lion",
	  dir = "/nvim_path_to_replace/plugins/vim-lion"
	},
	{
	  "frazrepo/vim-rainbow",
	  dir = "/nvim_path_to_replace/plugins/vim-rainbow"
	},
  {
    "lukas-reineke/indent-blankline.nvim",
	  dir = "/nvim_path_to_replace/plugins/indent-blankline.nvim",
  },
  {
    "ntpeters/vim-better-whitespace",
	  dir = "/nvim_path_to_replace/plugins/vim-better-whitespace",
  },
})

-- Load personal prefrences.
require('settings')

-- Load personal keymaps.
require('maps')
