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

-- LSP remaps
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition)
vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation)
vim.keymap.set('n', '<leader>gb', '<C-o>')
vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

-- Default tab indents
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4

-- Plugins
vim.pack.add({
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/mfussenegger/nvim-lint' },
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim' },
    { src = 'https://github.com/catppuccin/nvim' },
    { src = 'https://github.com/NvChad/nvim-colorizer.lua' },
})

-- Color previews
require('colorizer').setup({
    filetypes = { '*' },
    user_default_options = {
        css = true,
        mode = 'background',
    },
})

-- LSP
vim.lsp.enable({
    'lua_ls',
    'pyright',
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
vim.cmd.colorscheme "catppuccin-macchiato"

-- Transparency NOTE: Must be AFTER color scheme setting
vim.cmd [[
    highlight Normal guibg=NONE ctermbg=NONE
    highlight NormalNC guibg=NONE ctermbg=NONE
    highlight SignColumn guibg=NONE ctermbg=NONE
    highlight VertSplit guibg=NONE ctermbg=NONE
    highlight LineNr guibg=NONE ctermbg=NONE
    highlight EndOfBuffer guibg=NONE ctermbg=NONE
]]

-- Telescope
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files)
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep)
