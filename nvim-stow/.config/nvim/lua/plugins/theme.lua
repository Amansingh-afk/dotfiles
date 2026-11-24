local theme = os.getenv("DOTFILES_THEME") or "gruvbox"

return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    cond = theme == "gruvbox",
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true,
        contrast = "hard",
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
      })
      vim.cmd("colorscheme gruvbox")
    end,
  },
  {
    "oskarnurm/koda.nvim",
    lazy = false,
    priority = 1000,
    cond = theme == "monochrome",
    config = function()
      vim.cmd("colorscheme koda")
      -- Glass: transparent background
      vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
    end,
  },
}
