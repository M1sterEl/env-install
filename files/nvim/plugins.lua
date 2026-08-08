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
    'akinsho/toggleterm.nvim',
    dir = "/nvim_path_to_replace/plugins/toggleterm.nvim",
    version = "*",
    config = true
  },
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
	  -- Highlights other occurrences of the word under the cursor.
	  "echasnovski/mini.cursorword",
	  dir = "/nvim_path_to_replace/plugins/mini.cursorword",
	  config = function()
	    require("mini.cursorword").setup()
	  end,
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
  {
    -- Builtin ftplugins (e.g. ftplugin/lua.lua) call vim.treesitter.start()
    -- unconditionally when a matching file is opened. Without a compiled
    -- parser available on 'runtimepath' that call throws
    -- "Parser could not be created for buffer ... and language" on every
    -- such buffer. nvim-treesitter just installs the parsers this needs;
    -- highlighting itself is Neovim core's vim.treesitter.start(), not a
    -- plugin API (the "main" branch dropped the old configs.setup() shim),
    -- so this doesn't touch LSP or nvim-cmp.
    "nvim-treesitter/nvim-treesitter",
    dir = "/nvim_path_to_replace/plugins/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate", -- compiles/updates parsers, needs network + a C compiler (cc/gcc) on first run
    config = function()
      -- Plugins (e.g. Telescope's buffer previewer) call vim.treesitter.start()
      -- directly for whatever filetype is on screen, with no pcall of their
      -- own. For any language without an installed/compiled parser this
      -- throws "Parser could not be created ...". Patch the shared function
      -- once so every caller, ours and every plugin's, falls back to legacy
      -- regex/syntax highlighting instead of an error.
      local ts_start = vim.treesitter.start
      vim.treesitter.start = function(bufnr, lang)
        local ok, ret = pcall(ts_start, bufnr, lang)
        if ok then return ret end
        -- Signal failure like a normal ts_highlighter would, so callers that
        -- check the return value (e.g. Telescope) run their own regex
        -- fallback with the filetype they already know, instead of us
        -- guessing from a preview buffer's (often unset) 'filetype' option.
        bufnr = bufnr or vim.api.nvim_get_current_buf()
        pcall(function() vim.bo[bufnr].syntax = vim.bo[bufnr].filetype end)
        return false
      end

      -- To support a new language, just add its name here, e.g. "python", "bash", "markdown".
      local parsers = { "lua", "python", "gdscript", "terraform", "git_config", "git_rebase", "gitcommit", "gitignore", "gitattributes", "bash" , "markdown", "json", "dockerfile", "helm", "ini", "toml", "yaml", "zsh", "ssh_config", "diff"}

      -- Async install; if this hasn't finished yet (e.g. no network on first
      -- run) the FileType autocmd below still fires but the patched
      -- vim.treesitter.start() above no-ops instead of crashing.
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = parsers,
        callback = function() vim.treesitter.start() end,
      })
    end,
  },
})

-- Load personal prefrences.
require('settings')

-- Load personal keymaps.
require('maps')
