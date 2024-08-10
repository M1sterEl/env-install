local g = vim.g
local o = vim.o

-- Theme
vim.cmd([[set termguicolors]])
g.gruvbox_contrast_light = 'soft'

function set_tab(n)
	o.tabstop = n
	o.shiftwidth = n
	o.softtabstop = n
	o.expandtab = true
	o.autoindent = true
	o.smartindent = true
end

function trim()
	local save = vim.fn.winsaveview()
	vim.cmd([[keeppatterns %s/\s\+$//e]])
	vim.fn.winrestview(save)
end

vim.api.nvim_create_user_command('SetTab', function(opts) set_tab(tonumber(opts.args)) end, {nargs=1})
vim.api.nvim_create_user_command('Trim', trim, {nargs=0})


-- Editor options
o.mouse = 'a' -- Enable mouse support
o.clipboard = 'unnamedplus' -- Use system clipboard
o.encoding = "utf-8" -- Set file encoding as utf-8

o.syntax = 'on' -- Enable syntax highlighting
o.number = true -- Enable line nubmers
o.relativenumber = true -- Enable relative numbers
o.ruler = true -- Enable ruler
o.title = true -- Set correct title
o.laststatus = 2 -- Always show status line
o.cursorline = true
o.scrolloff = 6 -- Set to have 6 lines between the cursor and end of screen
o.spell = true -- Set spell checking
o.splitright = true -- Set to split new files to right
o.ignorecase = true -- Set search to be case insensitive
o.wrap = false -- Set the text to not wrap
o.list = true -- Set to show trailing whitespace

set_tab(4) -- Default tab value is 4

o.autoread = true -- Enable auto read of the file change

-- Undo extensions
o.undodir = vim.fn.expand('~/.cache/nvim/undodir')
o.undofile = true

-- Highlight search results
o.hlsearch = true
o.incsearch = true

-- Open file on the same line it was closed
vim.api.nvim_create_autocmd({"BufReadPost"}, {
	pattern = {"*"},
	callback = function()
		if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
			vim.api.nvim_exec("normal! g'\"",false)
		end
	end
})

-- Setup indent lines using the indent-blankline plugin
require("ibl").setup {
    scope = { enabled = false },
}

-- Declared here for all other lspconfig settings
lspconfig = require("lspconfig")
-- To allow for better autocompletion, this needs to be added to every new lsp server defintion
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Setup telescope
local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    -- To let telescope show hidden files, we set a flag when running the telescope command.
    -- In other words, we set the setting in the 'maps.lua' file.
    layout_strategy = "vertical",
    layout_config = {
      vertical = {
        preview_cutoff = 0,
        prompt_position = "bottom",
      },
    },
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<esc>"] = actions.close,
      },
    },
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
  },
}

-- Set up nvim-cmp (autocompletion plugin)
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'buffer' },
    { name = 'nvim_lsp' },
  })
})

-- C++
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "c", "cpp", "objc" },
	callback = function()
		o.formatprg = 'clang-format'
		o.equalprg = 'clang-format'
		set_tab(4)
	end
})

-- Needs clangd to installed to work
lspconfig.clangd.setup({
  on_attach = lsp_attach,
    capabilities = capabilities,
    cmd = { "/usr/bin/clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    root_dir = lspconfig.util.root_pattern(
      '.clangd'
      ,'.clang-tidy'
      ,'.clang-format'
      ,'compile_commands.json'
      ,'compile_flags.txt'
      ,'configure.ac'
      ,'.git'
      ),
    -- Prevents indexing, speeds up the lsp
    single_file_support = true,
})

-- Python
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "python" },
	callback = function()
		set_tab(4)
	end
})

lspconfig.pylsp.setup {
  on_attach = custom_attach,
    settings = {
      pylsp = {
        plugins = {
          -- formatter options
          black = { enabled = false },
          autopep8 = { enabled = false },
          yapf = { enabled = false },
          -- linter options
          pylint = { enabled = false, executable = "pylint" },
          pyflakes = { enabled = false },
          pycodestyle = { enabled = false },
          -- type checker
          pylsp_mypy = { enabled = true },
          -- import sorting
          pyls_isort = { enabled = true },
        },
      },
    },
  flags = {
      debounce_text_changes = 200,
  },
  capabilities = capabilities,
}

-- Rust
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "rust" },
	callback = function()
		set_tab(4)
	end
})

-- Lua
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "lua" },
	callback = function()
		set_tab(2)
	end
})

-- Groovy
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "groovy" },
	callback = function()
		set_tab(4)
	end
})

-- Jenkinsfile
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "Jenkinsfile" },
	callback = function()
		o.syntax = 'groovy'
		set_tab(4)
	end
})

-- Bash
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'sh',
  callback = function()
    vim.lsp.start({
      name = 'bash-language-server',
      cmd = { 'bash-language-server', 'start' },
      capabilities = capabilities,
    })
  end,
})
