-- Language-specific plugins

return {
  -- Rust
  {
    'rust-lang/rust.vim',
    ft = 'rust',
    init = function()
      vim.g.cargo_makeprg_params = 'build'
      vim.g.cargo_shell_command_runner = 'Start'
    end,
  },

  -- Zig
  {
    'ziglang/zig.vim',
    ft = 'zig',
  },
}
