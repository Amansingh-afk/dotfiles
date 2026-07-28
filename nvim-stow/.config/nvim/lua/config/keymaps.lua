local keymap = vim.keymap
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "

local status_ok, wk = pcall(require, "which-key")
if not status_ok then
  return
end

local function term(cmd)
  return function()
    local Terminal = require("toggleterm.terminal").Terminal
    Terminal:new({ cmd = cmd, hidden = true }):toggle()
  end
end

wk.add({
  { "<leader>w", group = "Window" },
  { "<leader>ws", ":split<CR>", desc = "Split Horizontal" },
  { "<leader>wv", ":vsplit<CR>", desc = "Split Vertical" },
  { "<leader>wc", ":q<CR>", desc = "Close Window" },
  { "<leader>wn", "<C-w>w", desc = "Next Window" },
  { "<leader>wp", "<C-w>W", desc = "Previous Window" },
  { "<leader>w=", "<C-w>=", desc = "Equal Width" },
  { "<leader>w>", "<C-w>>", desc = "Increase Width" },
  { "<leader>w<", "<C-w><", desc = "Decrease Width" },
  { "<leader>w+", "<C-w>+", desc = "Increase Height" },
  { "<leader>w-", "<C-w>-", desc = "Decrease Height" },

  { "<leader>b", group = "Buffer" },
  { "<leader>bn", ":bnext<CR>", desc = "Next Buffer" },
  { "<leader>bp", ":bprevious<CR>", desc = "Previous Buffer" },
  { "<leader>bd", ":bdelete<CR>", desc = "Delete Buffer" },
  { "<leader>bl", ":buffers<CR>", desc = "List Buffers" },
  { "<leader>bx", "<Cmd>BufferLinePickClose<CR>", desc = "Pick Buffer to Close" },
  { "<leader>bX", "<Cmd>BufferLineCloseOthers<CR>", desc = "Close Other Buffers" },

  { "<leader>e", group = "Explorer" },
  { "<leader>ee", ":NvimTreeToggle<CR>", desc = "Toggle Explorer" },
  { "<leader>ef", ":NvimTreeFindFile<CR>", desc = "Find Current File" },
  { "<leader>er", ":NvimTreeRefresh<CR>", desc = "Refresh Explorer" },

  { "<leader>f", group = "Find" },
  { "<leader>ff", ":Telescope find_files<CR>", desc = "Find Files" },
  { "<leader>fg", ":Telescope live_grep<CR>", desc = "Live Grep" },
  { "<leader>fb", ":Telescope buffers<CR>", desc = "Find Buffers" },
  { "<leader>fh", ":Telescope help_tags<CR>", desc = "Help Tags" },
  { "<leader>fr", ":Telescope oldfiles<CR>", desc = "Recent Files" },
  { "<leader>fz", "<cmd>Telescope zoxide list<CR>", desc = "Jump via zoxide" },

  { "<leader>c", group = "Code" },
  { "<leader>cF", function() vim.lsp.buf.format({ async = true }) end, desc = "Format Code" },

  { "<leader>t", group = "Terminal" },
  { "<leader>tt", "<cmd>ToggleTerm<CR>", desc = "Toggle Terminal" },
  { "<leader>tg", term("lazygit"), desc = "Git Terminal" },
  { "<leader>tn", term("node"), desc = "Node Terminal" },
  { "<leader>tp", term("python"), desc = "Python Terminal" },
})

keymap.set("n", "<C-h>", "<C-w>h", opts)
keymap.set("n", "<C-j>", "<C-w>j", opts)
keymap.set("n", "<C-k>", "<C-w>k", opts)
keymap.set("n", "<C-l>", "<C-w>l", opts)

keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

keymap.set("n", "<C-d>", "<C-d>zz", opts)
keymap.set("n", "<C-u>", "<C-u>zz", opts)
keymap.set("n", "n", "nzzzv", opts)
keymap.set("n", "N", "Nzzzv", opts)

keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end, { desc = "LSP References" })
