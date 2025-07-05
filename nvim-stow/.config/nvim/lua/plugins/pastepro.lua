return {
  dir = "/home/dmann/realm/builds/pasterpro.nvim",
  name = "pastepro.nvim",
  event = "VeryLazy",
  config = function()
    require("pastepro").setup({
      patterns = {
        "^%s*%d+[.)]%s*",      -- Numbered lists
        "^%s*[%*%-+]%s*",      -- Bullet points
        "^%s*<%?%?%?%>%s*",    -- Placeholder markers
        "^%s*//%s*",            -- Comment markers
        "^%s*#%s*",             -- Hash comments
        "^%s*<!--%s*.-%s*-->%s*" -- HTML comments
      },
      highlight_duration = 1500,
      highlight_group = "Visual"
    })
  end
}
