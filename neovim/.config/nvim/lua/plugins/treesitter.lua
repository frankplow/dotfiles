-- Treesitter configuration
--
-- nvim-treesitter's old `master`/v0.10.0 API is incompatible with Neovim
-- 0.12's core treesitter changes (breaks markdown highlighting, among other
-- things), so this uses the rewritten `main` branch, which only installs
-- parsers/queries; highlighting is started via Neovim's built-in
-- vim.treesitter.start() instead of the plugin's old configs.setup().

-- Maps filetype -> treesitter language, for cases where they differ.
local ft_to_lang = {
  sh = "bash",
}

local langs = { "comment", "c", "cpp", "rust", "python", "vim", "ocaml", "bash", "markdown", "markdown_inline" }
local filetypes = { "c", "cpp", "rust", "python", "vim", "ocaml", "sh", "markdown" }

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    lazy = false,
    config = function()
      require('nvim-treesitter').install(langs)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function(args)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
          if ok and stats and stats.size > max_filesize then
            return
          end
          local lang = ft_to_lang[args.match] or args.match
          vim.treesitter.start(args.buf, lang)
        end,
      })
    end,
  },
}
