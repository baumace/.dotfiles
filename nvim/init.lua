vim.g.mapleader = " "

-- Line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Basic remaps
vim.keymap.set('n', '<leader>efs', ':Ex<CR>') -- Explore file system

-- Default tab indents
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4

-- Plugins
vim.pack.add({
    { src = 'https://github.com/neovim/nvim-lspconfig' },
})

-- LSP
vim.lsp.enable({ 'lua_ls' })
