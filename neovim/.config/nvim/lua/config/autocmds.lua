-- Neovim-specific autocommands

-- FZF: Allow escape to close fzf windows
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'fzf',
  callback = function()
    vim.keymap.set('t', '<esc>', '<c-c>', { buffer = true })
  end
})
