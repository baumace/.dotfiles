--  NOTE: I have removed some of the comments as I have read them and do not need to reed them in the future.
--[[

Kickstart Guide:

  See `:help lua-guide` as a reference for how Neovim integrates Lua.
  - :help lua-guide

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

--]]

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Setting options
require 'options'

-- Basic Keymaps
require 'keymaps'

-- Install `lazy.nvim` plugin manager
require 'lazy-bootstrap'

-- Configure and install plugins
require 'lazy-plugins'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
