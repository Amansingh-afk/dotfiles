return {
  "salkhalil/summon.nvim",
  opts = {
    width = 0.85,
    height = 0.85,
    border = "rounded",
    commands = {
      claude = {
        type = "terminal",
        command = "claude",
        title = " Claude ",
        keymap = "<leader>cc",
      },
      todos = {
        type = "file",
        command = "~/todo.txt",
        title = " TODOs ",
        keymap = "<leader>td",
      },
    },
  },
}
