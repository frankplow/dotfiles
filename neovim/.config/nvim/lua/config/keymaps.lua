-- Neovim-specific keymaps (plugin-dependent)

-- vim-dispatch keymaps
vim.keymap.set('n', "'<CR>", ":Start! -wait=always<CR>", { silent = true })
vim.keymap.set('n', "'!", ":Start! -wait=always ")

-- gR is used for LSP navigation, so rebind <leader>R to enter VREPLACE
vim.keymap.set('n', '<leader>R', 'gR', { silent = true })

-- FZF keymaps
vim.keymap.set('n', 'g<CR>', ':History<CR>', { silent = true })
vim.keymap.set('n', 'g/', ':Rg<CR>', { silent = true })
vim.keymap.set('n', 'g*', ':Rg <C-R><C-W><CR>', { silent = true })
