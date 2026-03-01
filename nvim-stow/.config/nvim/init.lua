-- Neovim Configuration for Software Development
-- Custom Theme with LSP, Treesitter, and more

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local theme = os.getenv("DOTFILES_THEME") or "gruvbox"
if theme == "retrov2" then
  vim.o.background = "light"
else
  vim.o.background = "dark"
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Initialize lazy.nvim with all plugins
require("lazy").setup({
  -- Load plugins from the lua/plugins directory
  { import = "plugins" },
}, {
  change_detection = {
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Load configurations
require("config.options")    -- Basic vim options
require("config.keymaps")   -- Key mappings


