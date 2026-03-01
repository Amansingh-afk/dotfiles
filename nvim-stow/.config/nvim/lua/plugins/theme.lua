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
        transparent_background = true,
        term_colors = true,
        dim_inactive = { enabled = true, percentage = 0.15 },
        no_italic = false,
        no_bold = false,
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          keywords = { "italic" },
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
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    cond = theme == "retro",
    config = function()
      -- BSOD / DOS blue screen aesthetic
      vim.cmd("colorscheme blue")
      -- Override key groups for authentic BSOD feel
      local bg = "#0000AA"
      local fg = "#FFFFFF"
      local gray = "#AAAAAA"
      local cyan = "#55FFFF"
      local yellow = "#FFFF55"
      local green = "#55FF55"
      local red = "#FF5555"
      vim.api.nvim_set_hl(0, "Normal", { fg = fg, bg = bg })
      vim.api.nvim_set_hl(0, "NormalFloat", { fg = fg, bg = "#000080" })
      vim.api.nvim_set_hl(0, "Comment", { fg = gray })
      vim.api.nvim_set_hl(0, "String", { fg = green })
      vim.api.nvim_set_hl(0, "Keyword", { fg = cyan, bold = true })
      vim.api.nvim_set_hl(0, "Function", { fg = yellow })
      vim.api.nvim_set_hl(0, "Type", { fg = cyan })
      vim.api.nvim_set_hl(0, "Number", { fg = green })
      vim.api.nvim_set_hl(0, "Constant", { fg = yellow })
      vim.api.nvim_set_hl(0, "Identifier", { fg = fg })
      vim.api.nvim_set_hl(0, "Statement", { fg = cyan, bold = true })
      vim.api.nvim_set_hl(0, "PreProc", { fg = yellow })
      vim.api.nvim_set_hl(0, "Special", { fg = "#FF55FF" })
      vim.api.nvim_set_hl(0, "Error", { fg = fg, bg = red })
      vim.api.nvim_set_hl(0, "WarningMsg", { fg = yellow })
      vim.api.nvim_set_hl(0, "LineNr", { fg = "#555555", bg = bg })
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = yellow, bg = bg })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "#000080" })
      vim.api.nvim_set_hl(0, "Visual", { fg = "#000000", bg = gray })
      vim.api.nvim_set_hl(0, "StatusLine", { fg = "#000000", bg = gray })
      vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#555555", bg = "#000080" })
      vim.api.nvim_set_hl(0, "Pmenu", { fg = fg, bg = "#000080" })
      vim.api.nvim_set_hl(0, "PmenuSel", { fg = "#000000", bg = gray })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = bg })
      vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#555555", bg = bg })
      vim.api.nvim_set_hl(0, "WinBar", { fg = fg, bg = "#000080" })
      vim.api.nvim_set_hl(0, "WinBarNC", { fg = gray, bg = "#000080" })
      vim.api.nvim_set_hl(0, "TabLine", { fg = gray, bg = "#000080" })
      vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#000000", bg = gray })
      vim.api.nvim_set_hl(0, "TabLineFill", { bg = "#000080" })
    end,
  },
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    cond = theme == "retrov2",
    config = function()
      require("github-theme").setup({
        options = {
          transparent = false,
          terminal_colors = true,
          styles = {
            comments = "italic",
          },
        },
      })
      vim.cmd("colorscheme github_light")
    end,
  },
} 