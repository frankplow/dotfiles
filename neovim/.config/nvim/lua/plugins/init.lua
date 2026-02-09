-- Main plugin configuration

return {
  -- Core editor plugins from tpope
  {
    'tpope/vim-sensible',
  },

  {
    'tpope/vim-surround',
  },

  {
    'tpope/vim-commentary',
  },

  {
    'tpope/vim-sleuth',
  },

  {
    'tpope/vim-dispatch',
  },

  {
    'tpope/vim-fugitive',
  },

  {
    'tpope/vim-repeat',
  },

  {
    'tpope/vim-unimpaired',
  },

  -- Git integration
  {
    'airblade/vim-gitgutter',
    init = function()
      vim.g.gitgutter_sign_added = '┃'
      vim.g.gitgutter_sign_modified = '┃'
      vim.g.gitgutter_sign_removed = '┃'
      vim.g.gitgutter_sign_removed_first_line = '┃'
      vim.g.gitgutter_sign_removed_above_and_below = '┃'
      vim.g.gitgutter_sign_modified_removed = '┃'
    end
  },

  -- Sudo support
  {
    'lambdalisue/suda.vim',
  },

  -- FZF fuzzy finder
  {
    'junegunn/fzf',
    build = './install --bin',
  },

  {
    'junegunn/fzf.vim',
    dependencies = { 'junegunn/fzf' },
    cmd = { 'Files', 'Rg', 'History' },
  },

  -- Tmux integration
  {
    'christoomey/vim-tmux-navigator',
  },

  -- LSP, Treesitter, and other complex plugins loaded from separate files
  require('plugins.lsp'),
  require('plugins.treesitter'),
  require('plugins.completion'),
  require('plugins.languages'),
  require('plugins.formatting'),
}
