return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    win = {
      border = "single",
    },
    spec = {
      { "<leader>d", group = "Debug" },
      { "<leader>g", group = "Git" },
      { "g", group = "Go to" },
    },
  },
}
