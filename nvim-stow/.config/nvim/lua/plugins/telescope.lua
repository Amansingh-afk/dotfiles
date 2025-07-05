return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-tree/nvim-web-devicons",
      "jvgrootveld/telescope-zoxide",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          path_display = { "smart" },
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("zoxide")

      -- Set highlight groups to follow colorscheme
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          local colors = vim.api.nvim_get_hl(0, { name = "Normal" })
          local bg = string.format("#%06x", colors.bg or 0)
          local fg = string.format("#%06x", colors.fg or 0)
          
          -- Link Telescope highlights to your colorscheme
          vim.api.nvim_set_hl(0, "TelescopeNormal", { link = "Normal" })
          vim.api.nvim_set_hl(0, "TelescopeBorder", { link = "FloatBorder" })
          vim.api.nvim_set_hl(0, "TelescopePromptNormal", { link = "Normal" })
          vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { link = "Normal" })
          vim.api.nvim_set_hl(0, "TelescopeSelection", { link = "Visual" })
          vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { link = "Visual" })
          vim.api.nvim_set_hl(0, "TelescopePromptTitle", { link = "Title" })
          vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { link = "Title" })
          vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { link = "Title" })
        end,
      })
    end,
  },
} 