local map = function(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, {silent = true})
end

local noremap = function(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, {silent = true, noremap = true})
end

-- Genral
noremap('n', 'Q', '<CMD>noh<CR>') -- Disable search hilight
noremap('n', '<leader>t', '<CMD>trim<CR>') -- Trim whitespaces
noremap('n', 'nl', 'o<Esc>') -- Add a black line below
noremap('n', 'sa', 'gg0vG$') -- Visual select the entire file

-- Tabs
noremap('n', '<leader>tn', '<CMD>tabnew<CR>') -- Tab new
noremap('n', '<leader>tc', '<CMD>tabclose<CR>') -- Tab close
noremap('n', '<leader>to', '<CMD>tabonly<CR>') -- Tab only
noremap('n', '<leader>tmn', '<CMD>+tabmove<CR>') -- Tab move
noremap('n', '<leader>tmp', '<CMD>-tabmove<CR>') -- Tab move

-- Buffers
noremap('n', '<leader>bw', '<CMD>bw<CR>') -- Buffer close
noremap('n', '<leader>bn', '<CMD>bn<CR>') -- Buffer forward
noremap('n', '<leader>bp', '<CMD>bp<CR>') -- Buffer backward

-- Window management
noremap('n', '<leader>vmp', '<CMD>leftabove vsplit %<CR>')
noremap('n', '<leader>xmp', '<CMD>leftabove vsplit %<CR>')

-- Window navigation
noremap('n', '<C-h>', '<C-w>h') -- Go left
noremap('n', '<C-l>', '<C-w>l') -- Go right
noremap('n', '<C-k>', '<C-w>k') -- Go up
noremap('n', '<C-j>', '<C-w>j') -- Go down
noremap('n', '<C-S-h>', '<C-w>H') -- Move left
noremap('n', '<C-S-l>', '<C-w>L') -- Move right
noremap('n', '<C-S-k>', '<C-w>K') -- Move up
noremap('n', '<C-S-j>', '<C-w>J') -- Move down

-- Window resize
noremap('n', '<C-Left>', '<C-w><')
noremap('n', '<C-Right>', '<C-w>>')
noremap('n', '<C-Up>', '<C-w>+')
noremap('n', '<C-Down>', '<C-w>-')

-- NeoTree
noremap('n', '<C-\\>', '<CMD>Neotree toggle<CR>') -- Neotree toggle

-- fzf
noremap('n', '<leader>f', '<CMD>Files<CR>')
noremap('n', '<leader><leader>', '<CMD>Rg<CR>')
