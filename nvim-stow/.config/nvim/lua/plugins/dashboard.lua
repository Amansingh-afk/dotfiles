return {
  'glepnir/dashboard-nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local header = {
      "                                                     ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                     ",
      " [ TIP: To exit Neovim, press ALT+F4 multiple times ]",
      "                                                     ",
    }

    local center = {
      {
        icon = "󰈞 ",
        icon_hl = "Title",
        desc = "Find File",
        desc_hl = "String",
        key = "f",
        key_hl = "Number",
        action = "Telescope find_files",
      },
      {
        icon = "󰊄 ",
        icon_hl = "Title",
        desc = "Recent Files",
        desc_hl = "String",
        key = "r",
        key_hl = "Number",
        action = "Telescope oldfiles",
      },
      {
        icon = "󰈬 ",
        icon_hl = "Title",
        desc = "Find Word",
        desc_hl = "String",
        key = "w",
        key_hl = "Number",
        action = "Telescope live_grep",
      },
      {
        icon = "󰊄 ",
        icon_hl = "Title",
        desc = "New File",
        desc_hl = "String",
        key = "n",
        key_hl = "Number",
        action = "enew",
      },
      {
        icon = "󰗼 ",
        icon_hl = "Title",
        desc = "Lazy",
        desc_hl = "String",
        key = "l",
        key_hl = "Number",
        action = "Lazy",
      },
      {
        icon = "󰒲 ",
        icon_hl = "Title",
        desc = "Mason",
        desc_hl = "String",
        key = "m",
        key_hl = "Number",
        action = "Mason",
      },
    }

    -- Get the current time and load time
    local function footer()
      local total_plugins = #vim.tbl_keys(require("lazy").plugins())
      local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
      local version = vim.version()
      local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch
      
      -- Calculate load time
      local start_time = vim.g.start_time or vim.loop.hrtime()
      local load_time = (vim.loop.hrtime() - start_time) / 1e6 -- Convert to milliseconds
      local load_time_str = string.format("   Load time: %.2fms", load_time)

      return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info .. load_time_str
    end

    -- Store start time when Neovim starts
    vim.g.start_time = vim.loop.hrtime()

    require('dashboard').setup({
      theme = 'doom',
      config = {
        header = header,
        center = center,
        footer = { footer() },
      },
      hide = {
        statusline = false,
        tabline = false,
        winbar = false,
      },
    })

    -- Disable the signcolumn specifically for dashboard buffer
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'dashboard',
      callback = function()
        vim.opt_local.signcolumn = 'no'
      end
    })
  end,
} 
