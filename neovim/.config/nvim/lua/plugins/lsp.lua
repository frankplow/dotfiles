-- LSP configuration

return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      -- LSP keymaps set on attach
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
                         { buffer = args.buf, noremap = true })
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
                         { buffer = args.buf, noremap = true })
          vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition,
                         { buffer = args.buf, noremap = true })
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
                         { buffer = args.buf, noremap = true })
          vim.keymap.set('n', 'gr', vim.lsp.buf.references,
                         { buffer = args.buf, noremap = true })
          vim.keymap.set('n', 'gR', vim.lsp.buf.incoming_calls,
                         { buffer = args.buf, noremap = true })
          vim.keymap.set('n', ']g', vim.diagnostic.goto_next,
                         { buffer = args.buf, noremap = true })
          vim.keymap.set('n', '[g', vim.diagnostic.goto_prev,
                         { buffer = args.buf, noremap = true })

          vim.keymap.set('n', '<Leader>r', vim.lsp.buf.rename,
                         { buffer = args.buf, noremap = true})
          vim.keymap.set('n', '<Leader>a', vim.lsp.buf.code_action,
                         { buffer = args.buf, noremap = true})

          if client.server_capabilities.hoverProvider then
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })
          end
        end
      })

      -- Diagnostic configuration
      vim.diagnostic.config({
        severity_sort = true,
      })

      -- Zig-specific setting
      vim.g.zig_fmt_parse_errors = 0

      -- Get capabilities from blink.cmp if available
      local capabilities = nil
      local blink_exists, blink = pcall(require, 'blink.cmp')
      if blink_exists then
        capabilities = blink.get_lsp_capabilities()
      end

      -- Get lspfuzzy wrapper if available
      local lspfuzzy_exists, lspfuzzy = pcall(require, 'lspfuzzy')
      local on_attach = nil
      if lspfuzzy_exists then
        on_attach = function(client, _)
          client.request = lspfuzzy.wrap_request(client.request)
        end
      end

      -- LSP servers configuration
      local lsp_servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
          },
        },
        rust_analyzer = {},
        pyright = {},
        zls = {},
      }

      -- Setup each server
      for server, config in pairs(lsp_servers) do
        if capabilities then
          config.capabilities = capabilities
        end

        if on_attach then
          config.on_attach = on_attach
        end

        -- Use new API for nvim 0.11+, old API for older versions
        if vim.fn.has('nvim-0.11') == 1 then
          vim.lsp.config[server] = config
          vim.lsp.enable(server)
        else
          require('lspconfig')[server].setup(config)
        end
      end
    end,
  },

  -- LSP fuzzy finder integration
  {
    'ojroques/nvim-lspfuzzy',
    dependencies = { 'junegunn/fzf.vim' },
    cond = function()
      return vim.g.vscode == nil
    end,
    config = function()
      require('lspfuzzy').setup()
    end,
  },
}
