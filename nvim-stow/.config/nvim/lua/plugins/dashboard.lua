return {
  "glepnir/dashboard-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- Time-based greeting
    local function get_greeting()
      local hour = tonumber(os.date("%H"))
      local greeting = ""
      if hour >= 5 and hour < 12 then
        greeting = "󰼰  Morning, let's build something"
      elseif hour >= 12 and hour < 17 then
        greeting = "󱎓  Afternoon, time to ship"
      elseif hour >= 17 and hour < 21 then
        greeting = "󰖚  Evening, code flows best now"
      else
        greeting = "󰖔  Late night hacking, respect"
      end
      return greeting
    end

    -- Rotating quotes/tips
    local quotes = {
      "│ \"Simplicity is the ultimate sophistication.\" │",
      "│ \"First, solve the problem. Then, write the code.\" │",
      "│ \"Code is like humor. When you have to explain it, it's bad.\" │",
      "│ \"Make it work, make it right, make it fast.\" │",
      "│ \"The best error message is the one that never shows up.\" │",
      "│ \"Deleted code is debugged code.\" │",
      "│ \"It works on my machine. ¯\\_(ツ)_/¯\" │",
      "│ \"// TODO: fix this later (written mass ago)\" │",
    }
    math.randomseed(os.time())
    local random_quote = quotes[math.random(#quotes)]

    local header = {
      "",
      "",
      "",
      "                                                                       ",
      "       ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗          ",
      "       ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║          ",
      "       ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║          ",
      "       ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║          ",
      "       ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║          ",
      "       ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝          ",
      "                                                                       ",
      "  ┌───────────────────────────────────────────────────────────────────┐",
      "  " .. random_quote,
      "  └───────────────────────────────────────────────────────────────────┘",
      "",
      "                        " .. get_greeting(),
      "",
      "",
    }

    local center = {
      {
        icon = "   ",
        desc = "Find File                                        ",
        key = "f",
        action = "Telescope find_files",
      },
      {
        icon = "   ",
        desc = "Recent Files                                     ",
        key = "r",
        action = "Telescope oldfiles",
      },
      {
        icon = "   ",
        desc = "Find Word                                        ",
        key = "w",
        action = "Telescope live_grep",
      },
      {
        icon = "   ",
        desc = "New File                                         ",
        key = "n",
        action = "enew",
      },
      {
        icon = "   ",
        desc = "Config                                           ",
        key = "c",
        action = "e ~/.config/nvim/init.lua",
      },
      {
        icon = "   ",
        desc = "Quit                                             ",
        key = "q",
        action = "qa",
      },
    }

    local function footer()
      local stats = require("lazy").stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      local ver = vim.version()
      local version = " v" .. ver.major .. "." .. ver.minor .. "." .. ver.patch
      return {
        "",
        "",
        "───────────────────────────────────────────────────────────────────────────",
        "",
        "  󰂖 " .. stats.loaded .. "/" .. stats.count .. " plugins    󱑎 " .. ms .. "ms   " .. version .. "    " .. os.date(" %a, %d %b"),
        "",
      }
    end

    require("dashboard").setup({
      theme = "doom",
      config = {
        header = header,
        center = center,
        footer = footer,
      },
      hide = {
        statusline = true,
        tabline = true,
        winbar = true,
      },
    })

    -- Custom highlights for dashboard
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "dashboard",
      callback = function()
        vim.opt_local.signcolumn = "no"
        vim.opt_local.cursorline = false

        -- Gruvbox-compatible custom highlights
        local colors = {
          orange = "#fe8019",
          yellow = "#fabd2f",
          aqua = "#8ec07c",
          blue = "#83a598",
          purple = "#d3869b",
          red = "#fb4934",
          green = "#b8bb26",
          gray = "#928374",
          fg = "#ebdbb2",
        }

        vim.api.nvim_set_hl(0, "DashboardHeader", { fg = colors.orange, bold = true })
        vim.api.nvim_set_hl(0, "DashboardIcon", { fg = colors.aqua })
        vim.api.nvim_set_hl(0, "DashboardDesc", { fg = colors.fg })
        vim.api.nvim_set_hl(0, "DashboardKey", { fg = colors.yellow, bold = true })
        vim.api.nvim_set_hl(0, "DashboardFooter", { fg = colors.gray, italic = true })
      end,
    })
  end,
}
