return {
  -- Integrated terminal - because switching windows is so last century
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })

      -- Terminal keymaps - because terminal should be keyboard-friendly
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
      end

      -- Auto-set keymaps when terminal opens
      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

      -- Custom terminal commands - because convenience is key
      local Terminal = require("toggleterm.terminal").Terminal

      -- LazyGit terminal - for when you need to git stuff
      local git_terminal = Terminal:new({
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        size = 80,
      })

      -- Node terminal - for npm/yarn commands
      local node_terminal = Terminal:new({
        cmd = "node",
        hidden = true,
        direction = "float",
        size = 60,
      })

      -- Python terminal - for python stuff
      local python_terminal = Terminal:new({
        cmd = "python",
        hidden = true,
        direction = "float",
        size = 60,
      })

      -- Add keymaps for custom terminals
      vim.keymap.set("n", "<leader>tg", function()
        git_terminal:toggle()
      end, { desc = "Toggle Git Terminal" })

      vim.keymap.set("n", "<leader>tn", function()
        node_terminal:toggle()
      end, { desc = "Toggle Node Terminal" })

      vim.keymap.set("n", "<leader>tp", function()
        python_terminal:toggle()
      end, { desc = "Toggle Python Terminal" })

    end,
  },
} 