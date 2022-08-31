-- colour scheme
vim.api.nvim_command('colorscheme ansi16')

-- line numbers
vim.api.nvim_win_set_option(0, 'number', true)
vim.api.nvim_win_set_option(0, 'relativenumber', true)
vim.api.nvim_win_set_option(0, 'cursorline', true)
vim.api.nvim_win_set_option(0, 'cursorlineopt', 'number')
vim.api.nvim_win_set_option(0, 'numberwidth', 3)

-- vim:et:ts=4:sw=4
