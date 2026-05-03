-- ============================================================
-- Which-Key: Popup that shows available keybinds
-- ============================================================
-- When you press <leader> (or any prefix), a popup appears showing
-- all keymaps starting with that prefix and their descriptions.
-- Helps you remember/discover keybinds without documentation.
-- Repo: github.com/folke/which-key.nvim

-- ============================================================
-- This is not bad, but it is something that probably I will remove in the
-- future
-- ============================================================

return {
    "folke/which-key.nvim",
    event = "VeryLazy",  -- load after startup
    opts = {
        -- ── Preset ──────────────────────────────────────────
        -- "modern" = newer UI with icons, "classic" = older style
        preset = "modern",

        -- ── Delay before popup appears (milliseconds) ───────
        -- 0 = instant, 1000 = wait 1 second
        delay = 300,

        -- ── Window appearance ───────────────────────────────
        win = {
            border = "rounded",      -- match catppuccin's rounded style
            padding = { 1, 2 },      -- {top/bottom, left/right}
        },

        -- ── Layout of the popup ─────────────────────────────
        layout = {
            width = { min = 20 },    -- minimum width of columns
            spacing = 3,             -- spacing between columns
        },

        -- ── Disable on these keys (don't show popup) ────────
        -- These are usually bindings you use without thinking
        disable = {
            ft = {},
            bt = {},
        },

        -- ── Icons in the popup ──────────────────────────────
        icons = {
            breadcrumb = "»",        -- separator between groups
            separator = "➜",         -- between key and description
            group = "+",             -- prefix for groups
            mappings = true,         -- show icons next to mappings
        },

        -- ── Sort order of keybind list ──────────────────────
        sort = { "local", "order", "group", "alphanum", "mod" },
    },

    -- ── Keymaps for which-key itself ────────────────────────
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },

    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)

        -- ── Register groups for better organization ─────────
        -- These group labels appear in the popup to organize keymaps
        wk.add({
            { "<leader>b", group = "Buffer" },
            { "<leader>c", group = "Code/Quickfix" },
            { "<leader>l", group = "Location List" },
            { "<leader>p", group = "Project/Paste" },
            { "<leader>s", group = "Search/Replace" },
            { "<leader>w", group = "Write/Window" },
            { "<leader>R", group = "Resize Mode" },
        })
    end,
}
