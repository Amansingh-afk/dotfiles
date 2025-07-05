local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Line wrapping
opt.wrap = false

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.updatetime = 250
opt.colorcolumn = ""
opt.winbar = "%=%m %f" -- Enable winbar

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Split windows
opt.splitright = true
opt.splitbelow = true

-- Consider - as part of keyword
opt.iskeyword:append("-")

-- Disable swapfile
opt.swapfile = false

-- Performance
opt.lazyredraw = true
opt.synmaxcol = 240

-- Backup
opt.backup = false
opt.writebackup = false

-- UI
opt.showmatch = true
opt.showmode = false
opt.wildmenu = true
opt.wildmode = "list:longest"
opt.completeopt = "menuone,noselect"
opt.sidescrolloff = 8

-- Diagnostics
opt.shortmess:append("c")

-- Enable diagnostics with modern configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = {
    active = true,
    values = {
      { name = "DiagnosticSignError", text = " " },
      { name = "DiagnosticSignWarn", text = " " },
      { name = "DiagnosticSignHint", text = " " },
      { name = "DiagnosticSignInfo", text = " " },
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}) 