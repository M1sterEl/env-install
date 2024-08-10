local lazypath = "/home/user_name_to_replace/.config/nvim/plugins/lazy.nvim"
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
	  "morhetz/gruvbox",
	  priority = 100,
	  dir = "/home/user_name_to_replace/.config/nvim/plugins/gruvbox",
	  config = function()
	  vim.cmd([[colorscheme gruvbox]])
  	  end,
	},
	{
	  "neovim/nvim-lspconfig",
	  dir = "/home/user_name_to_replace/.config/nvim/plugins/nvim-lspconfig",
	   config = function()
	   end,
	},
  { "hrsh7th/nvim-cmp",
	  dir = "/home/user_name_to_replace/.config/nvim/plugins/nvim-cmp",
  },
  { 
    "hrsh7th/cmp-nvim-lsp",
	  dir = "/home/user_name_to_replace/.config/nvim/plugins/cmp-nvim-lsp",
  },
  {
    "hrsh7th/cmp-buffer",
	  dir = "/home/user_name_to_replace/.config/nvim/plugins/cmp-buffer",
  },
  {
    'nvim-telescope/telescope.nvim',
	  dir = "/home/user_name_to_replace/.config/nvim/plugins/telescope.nvim",
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
	{
	  "nvim-lua/plenary.nvim",
	  dir = "/home/user_name_to_replace/.config/nvim/plugins/plenary.nvim",
	},
	{
	  "MunifTanjim/nuy.nvim",
	  dir = "/home/user_name_to_replace/.config/nvim/plugins/nui.nvim"
	},
	{
	  "nvim-neo-tree/neo-tree.nvim",
	  dir = "/home/user_name_to_replace/.config/nvim/plugins/neo-tree.nvim"
	},
	{
	  "tpope/vim-surround",
	  dir = "/home/user_name_to_replace/.config/nvim/plugins/vim-surround"
	},
	{
	  "tpope/vim-commentary",
	  dir = "/home/user_name_to_replace/.config/nvim/plugins/vim-commentary"
	},
	{
	  "tpope/vim-fugitive",
	  dir = "/home/user_name_to_replace/.config/nvim/plugins/vim-fugitive"
	},
	{
	  "tpope/vim-abolish",
	  dir = "/home/user_name_to_replace/.config/nvim/plugins/vim-abolish"
	},
	{
	  "RRethy/vim-illuminate",
	  dir = "/home/user_name_to_replace/.config/nvim/plugins/vim-illuminate"
	},
	{
	  "sindrets/diffview.nvim",
	  dir = "/home/user_name_to_replace/.config/nvim/plugins/diffview.nvim"
	},
	{
	  "simrat39/symbols-outline.nvim",
	  dir = "/home/user_name_to_replace/.config/nvim/plugins/symbols-outline.nvim"
	},
	{
	  "tommcdo/vim-lion",
	  dir = "/home/user_name_to_replace/.config/nvim/plugins/vim-lion"
	},
	{
	  "frazrepo/vim-rainbow",
	  dir = "/home/user_name_to_replace/.config/nvim/plugins/vim-rainbow"
	},
  {
    "lukas-reineke/indent-blankline.nvim",
	  dir = "/home/user_name_to_replace/.config/nvim/plugins/indent-blankline.nvim",
  },
  {
    "ntpeters/vim-better-whitespace",
	  dir = "/home/user_name_to_replace/.config/nvim/plugins/vim-better-whitespace",
  },
})

-- Load personal prefrences.
require('settings')

-- Load personal keymaps.
require('maps')
