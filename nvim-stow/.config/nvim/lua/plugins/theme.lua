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
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    cond = theme == "catppuccin-mocha",
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        term_colors = true,
        dim_inactive = { enabled = false },
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          telescope = { enabled = true },
          which_key = true,
        },
      })
      vim.cmd("colorscheme catppuccin-mocha")
    end,
  },
  {
    "kdheepak/monochrome.nvim",
    lazy = false,
    priority = 1000,
    cond = theme == "monochrome",
    config = function()
      vim.cmd("colorscheme monochrome")
    end,
  },
} 