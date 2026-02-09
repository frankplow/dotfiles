-- Completion configuration

return {
  {
    'Saghen/blink.cmp',
    version = 'v1.0.0',
    cond = function()
      return vim.g.vscode == nil
    end,
    config = function()
      require('blink.cmp').setup()
    end,
  },
}
