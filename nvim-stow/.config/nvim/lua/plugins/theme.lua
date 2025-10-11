return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    local theme = os.getenv("DOTFILES_THEME") or "gruvbox"
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
    if theme == "monochrome" then
      -- approximate monochrome by using gruvbox with muted palette
      vim.o.background = "dark"
      vim.cmd("colorscheme gruvbox")
      -- reduce saturation via highlights
      vim.api.nvim_set_hl(0, "String", { fg = "#b3b3b3" })
      vim.api.nvim_set_hl(0, "Function", { fg = "#c2c2c2" })
      vim.api.nvim_set_hl(0, "Identifier", { fg = "#adadad" })
      vim.api.nvim_set_hl(0, "Statement", { fg = "#a0a0a0" })
      vim.api.nvim_set_hl(0, "Type", { fg = "#b0b0b0" })
    else
      vim.cmd("colorscheme gruvbox")
    end
  end,
} 