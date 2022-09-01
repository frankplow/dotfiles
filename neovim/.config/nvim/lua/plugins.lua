local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local compile_path = vim.fn.stdpath('config')..'/packer_compiled.vim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

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
                vim.api.nvim_set_var('cargo_shell_command_runner', 'Start')
                vim.api.nvim_set_var('rustfmt_autosave', true)
            end,
            ft = {'rust', 'toml'},
            after = 'vim-dispatch'
        }

        use {'sqwishy/vim-sqf-syntax', ft = {'sqf'}}

        use {'sevko/vim-nand2tetris-syntax', ft = {'hdl'}}

        if packer_bootstrap then
          require('packer').sync()
        end
   end,
    config = {compile_path = compile_path}
})

vim.cmd('source ' .. compile_path)

-- vim:et:ts=4:sw=4
