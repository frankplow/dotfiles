-- Code formatting with neoformat

return {
  {
    'sbdchd/neoformat',
    cmd = { 'Neoformat' },
    init = function()
      -- Neoformat configuration for ocaml
      vim.g.neoformat_ocaml_ocamlformat = {
        exe = 'ocamlformat',
        no_append = 1,
        stdin = 1,
        args = { '--enable-outside-detected-project', '--name', '"%:p"', '-' }
      }
      vim.g.neoformat_enabled_ocaml = { 'ocamlformat' }
      vim.g.neoformat_enabled_python = { 'black' }
    end,
    config = function()
      -- AutoFormat functionality
      local format_group = vim.api.nvim_create_augroup('Format', { clear = true })

      local function auto_format(enable)
        vim.g.rustfmt_autosave = enable

        if enable then
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = format_group,
            pattern = '*',
            callback = function()
              -- Try with undojoin first, fall back to normal if it fails
              local ok = pcall(function()
                vim.cmd('undojoin')
                vim.cmd('silent Neoformat')
              end)
              if not ok then
                vim.cmd('silent Neoformat')
              end
            end,
          })
        else
          vim.api.nvim_clear_autocmds({ group = format_group })
        end
      end

      -- Create user commands
      vim.api.nvim_create_user_command('EnableAutoFormat', function()
        auto_format(true)
      end, {})

      vim.api.nvim_create_user_command('DisableAutoFormat', function()
        auto_format(false)
      end, {})
    end,
  },
}
