vim.cmd [[packadd packer.nvim]]

local compile_path = require('packer/util').join_paths(
    vim.fn.stdpath('config'),
    'packer_compiled.vim'
)

require('packer').startup({
    function(use)
        use 'tpope/vim-sensible'

        use 'tpope/vim-surround'

        use 'tpope/vim-commentary'

        use 'tpope/vim-sleuth'

        use 'tpope/vim-repeat'

        use 'tpope/vim-dispatch'

        use 'tpope/vim-fugitive'

        use 'lambdalisue/suda.vim'

        use {'junegunn/fzf.vim', requires = {'junegunn/fzf'}}

        use {
            'heewa/vim-tmux-navigator', branch = 'add-no-wrap-option',
            config = function()
                vim.api.nvim_set_var('tmux_navigator_no_wrap', true)
            end
        }

        -- LSP
        use {
            'neoclide/coc.nvim', branch = 'release',
            config = function()
                vim.fn['coc#util#install_extension']({'coc-clangd',
                                                      'coc-rust-analyzer'})

                vim.api.nvim_create_autocmd('CursorHold', {
                      callback = function()
                          vim.fn.CocActionAsync('highlight')
                      end,
                })
            end
        }

        use {'antoinemadec/coc-fzf', after = {'fzf.vim', 'coc.nvim'}}

        -- language-specific
        use {
            'rust-lang/rust.vim',
            config = function()
                vim.api.nvim_set_var('cargo_makeprg_params', 'build')
            end,
            ft = {'rust', 'toml'}
        }

        use {'sqwishy/vim-sqf-syntax', ft = {'sqf'}}

        use {'sevko/vim-nand2tetris-syntax', ft = {'hdl'}}
   end,
    config = {compile_path = compile_path}
})

vim.cmd('source ' .. compile_path)

-- vim:et:ts=4:sw=4
