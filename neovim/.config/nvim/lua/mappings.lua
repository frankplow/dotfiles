vim.api.nvim_set_keymap(
    'n',
    '<ESC>',
    ':noh<CR>',
    {noremap = true, silent = true}
)

vim.api.nvim_set_keymap(
    'n',
    'K',
    ':ShowDocumentation<CR>',
    {noremap = true}
)

if packer_plugins["vim-fugitive"] then
    vim.api.nvim_set_keymap(
        'n',
        '\'<CR>',
        ':Start -wait=always<CR>',
        {noremap = true}
    )
    vim.api.nvim_set_keymap(
        'n',
        '\'!',
        ':Start! -wait=always',
        {noremap = true}
    )
end

if packer_plugins["fzf.vim"] then
    local rg_cmd = 'rg --column --line-number --no-heading --color=always --smart-case -- '
    vim.api.nvim_set_keymap(
        'n',
        'g/',
        ':call fzf#vim#grep("' .. rg_cmd .. '\\"\\"", 1, fzf#vim#with_preview(), 0)<CR>',
        {noremap = true}
    )
    vim.api.nvim_set_keymap(
        'n',
        'g*',
        ':call fzf#vim#grep("' .. rg_cmd .. '\\"<C-R><C-W>\\"", 1, fzf#vim#with_preview(), 0)<CR>',
        {noremap = true}
    )
    vim.api.nvim_set_keymap(
        'n',
        'g<CR>',
        ':Buffers<CR>',
        {noremap = true}
    )
end

if packer_plugins["coc.nvim"] then
    -- completion
    vim.api.nvim_set_keymap(
        'i',
        '<TAB>',
        'coc#pum#visible() ? coc#pum#next(1) : "\\<TAB>"',
        {noremap = true, silent = true, expr = true}
    )
    vim.api.nvim_set_keymap(
        'i',
        '<S-TAB>',
        'coc#pum#visible() ? coc#pum#prev(1) : "\\<TAB>"',
        {noremap = true, silent = true, expr = true}
    )
    vim.api.nvim_set_keymap(
        'i',
        '<CR>',
        'coc#pum#visible() ? coc#pum#confirm() : "\\<CR>"',
        {noremap = true, silent = true, expr = true}
    )

    -- goto navigation
    vim.api.nvim_set_keymap(
        'n',
        'gd',
        '<Plug>(coc-definition)',
        {silent = true}
    )
    vim.api.nvim_set_keymap(
        'n',
        'gy',
        '<Plug>(coc-type-definition)',
        {silent = true}
    )
    vim.api.nvim_set_keymap(
        'n',
        'gi',
        '<Plug>(coc-implementation)',
        {silent = true}
    )
    vim.api.nvim_set_keymap(
        'n',
        'gr',
        '<Plug>(coc-references)',
        {silent = true}
    )
    vim.api.nvim_set_keymap(
        'n',
        ']g',
        '<Plug>(coc-diagnostic-next)',
        {silent = true}
    )
    vim.api.nvim_set_keymap(
        'n',
        '[g',
        '<Plug>(coc-diagnostic-prev)',
        {silent = true}
    )
end

-- vim:et:ts=4:sw=4
