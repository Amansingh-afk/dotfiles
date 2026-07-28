return {
  "max397574/better-escape.nvim",
  event = "InsertEnter",
  opts = {
    timeout = vim.o.timeoutlen,
    default_mappings = false,
    mappings = {
      i = {
        j = {
          j = "<Esc>",
          k = "<Esc>",
        },
      },
      c = {
        j = {
          j = "<Esc>",
          k = "<Esc>",
        },
      },
      t = {
        j = {
          k = "<C-\\><C-n>",
        },
      },
      v = {
        j = {
          k = "<Esc>",
        },
      },
      s = {
        j = {
          k = "<Esc>",
        },
      },
    },
  },
}
