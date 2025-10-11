-- Leader to be space
vim.g.mapleader = " "

-- Line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Basic remaps
vim.keymap.set('n', '<leader>ef', ':Ex<CR>') -- Explore files

-- Diagnostics remaps
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>d;', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>ds', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>dl', vim.diagnostic.open_float)

-- Default tab indents
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4

-- Plugins
vim.pack.add({
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/mfussenegger/nvim-lint' },
})

-- LSP
vim.lsp.enable({
    'lua_ls',
})

-- Linter
require('lint').linters_by_ft = {
    html = { 'htmlhint' },
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end,
})

-- Color scheme
-- Transparency
-- NOTE: Must be AFTER color scheme setting
-- vim.cmd [[
    -- highlight Normal guibg=NONE ctermbg=NONE
    -- highlight NormalNC guibg=NONE ctermbg=NONE
    -- highlight SignColumn guibg=NONE ctermbg=NONE
    -- highlight VertSplit guibg=NONE ctermbg=NONE
    -- highlight LineNr guibg=NONE ctermbg=NONE
    -- highlight EndOfBuffer guibg=NONE ctermbg=NONE
-- ]]
