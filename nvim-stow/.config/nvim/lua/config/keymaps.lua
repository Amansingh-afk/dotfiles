local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Set leader key to space
vim.g.mapleader = " "

-- Try to load WhichKey
local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

-- Normal mode keymaps with WhichKey labels
local normal_mappings = {
  ["<leader>"] = {
    -- Basic keybindings
    -- ["q"] = { ":q<CR>", "Quit" },
    -- ["w"] = { ":w<CR>", "Save" },
    -- ["wq"] = { ":wq<CR>", "Save and Quit" },
    
    -- Window management
    w = {
      name = "Window",
      s = { ":split<CR>", "Split Horizontal" },
      v = { ":vsplit<CR>", "Split Vertical" },
      c = { ":q<CR>", "Close Window" },
      n = { "<C-w>w", "Next Window" },
      p = { "<C-w>W", "Previous Window" },
      ["="] = { "<C-w>=", "Equal Width" },
      [">"] = { "<C-w>>", "Increase Width" },
      ["<"] = { "<C-w><", "Decrease Width" },
      ["+"] = { "<C-w>+", "Increase Height" },
      ["-"] = { "<C-w>-", "Decrease Height" },
    },

    -- Buffer management
    b = {
      name = "Buffer",
      n = { ":bnext<CR>", "Next Buffer" },
      p = { ":bprevious<CR>", "Previous Buffer" },
      d = { ":bdelete<CR>", "Delete Buffer" },
      l = { ":buffers<CR>", "List Buffers" },
      x = { "<Cmd>BufferLinePickClose<CR>", "Pick Buffer to Close" },
      X = { "<Cmd>BufferLineCloseOthers<CR>", "Close Other Buffers" },
    },

    -- File explorer
    e = {
      name = "Explorer",
      e = { ":NvimTreeToggle<CR>", "Toggle Explorer" },
      f = { ":NvimTreeFindFile<CR>", "Find Current File" },
      r = { ":NvimTreeRefresh<CR>", "Refresh Explorer" },
    },

    -- Find (Telescope) - because finding files should be a breeze
    f = {
      name = "Find",
      f = { ":Telescope find_files<CR>", "Find Files" },
      g = { ":Telescope live_grep<CR>", "Live Grep" },
      b = { ":Telescope buffers<CR>", "Find Buffers" },
      h = { ":Telescope help_tags<CR>", "Help Tags" },
      r = { ":Telescope oldfiles<CR>", "Recent Files" },
      z = { "<cmd>Telescope zoxide list<CR>", "Jump via zoxide" },
    },
    
    -- Code - because coding should be smooth
    c = {
      name = "Code",
      F = { function() vim.lsp.buf.format({ async = true }) end, "Format Code" },
    },

    -- Terminal - because integrated terminal is the future
    t = {
      name = "Terminal",
      t = { "<cmd>ToggleTerm<CR>", "Toggle Terminal" },
      g = { function() 
        local Terminal = require("toggleterm.terminal").Terminal
        local git_terminal = Terminal:new({cmd='lazygit', hidden=true})
        git_terminal:toggle()
      end, "Git Terminal" },
      n = { function() 
        local Terminal = require("toggleterm.terminal").Terminal
        local node_terminal = Terminal:new({cmd='node', hidden=true})
        node_terminal:toggle()
      end, "Node Terminal" },
      p = { function() 
        local Terminal = require("toggleterm.terminal").Terminal
        local python_terminal = Terminal:new({cmd='python', hidden=true})
        python_terminal:toggle()
      end, "Python Terminal" },
    },
  },
}

-- Window navigation
keymap.set("n", "<C-h>", "<C-w>h", opts)
keymap.set("n", "<C-j>", "<C-w>j", opts)
keymap.set("n", "<C-k>", "<C-w>k", opts)
keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Move lines up and down - because moving lines should be smooth
keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Keep cursor centered - because context is everything
keymap.set("n", "<C-d>", "<C-d>zz", opts)
keymap.set("n", "<C-u>", "<C-u>zz", opts)
keymap.set("n", "n", "nzzzv", opts)
keymap.set("n", "N", "Nzzzv", opts)

-- Better indenting - because indentation should be consistent
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

-- Diagnostic navigation - because errors should be easy to find
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- LSP References - because jumping to references should be quick
keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end, { desc = "LSP References" })

-- Register WhichKey mappings
which_key.register(normal_mappings)

-- Additional WhichKey configuration
which_key.setup({
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
    presets = {
      operators = true,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  window = {
    border = "single",
    position = "bottom",
    margin = { 1, 0, 1, 0 },
    padding = { 1, 2, 1, 2 },
  },
  layout = {
    height = { min = 4, max = 25 },
    width = { min = 20, max = 50 },
    spacing = 3,
    align = "left",
  },
  ignore_missing = true,
  show_help = true,
  triggers = "auto",
}) 