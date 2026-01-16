return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")

    wk.setup({
      win = {
        border = "single",
      },
    })

    -- Group labels
    wk.add({
      { "<leader>d", group = "Debug" },
      { "<leader>c", group = "Code" },
      { "<leader>w", group = "Workspace" },
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "g", group = "Go to" },
    })
  end,
} 