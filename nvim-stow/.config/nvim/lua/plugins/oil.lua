-- oil.nvim: a directory is a buffer. Edit names, dd to delete, :w to apply.
return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  opts = {
    default_file_explorer = true,      -- also replaces netrw for `nvim dir/`
    columns = { "icon" },
    view_options = { show_hidden = true },
    skip_confirm_for_simple_edits = true,
    float = { padding = 2, max_width = 100, max_height = 30, border = "rounded" },
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-v>"] = { "actions.select", opts = { vertical = true } },
      ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["q"] = "actions.close",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["gs"] = "actions.change_sort",
      ["g."] = "actions.toggle_hidden",
      ["<C-r>"] = "actions.refresh",
    },
  },
  keys = {
    { "-", "<cmd>Oil<CR>", desc = "Open parent directory (oil)" },
  },
}
