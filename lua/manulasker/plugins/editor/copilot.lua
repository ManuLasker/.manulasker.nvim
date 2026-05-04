return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
        require("copilot").setup({
            suggestion = { enabled = false },  -- disable ghost text, cmp handles it
            panel      = { enabled = false },  -- disable panel, codecompanion handles it
            filetypes  = {
                markdown = true,
                yaml     = true,
                ["*"]    = true,
            },
        })
    end,
}

