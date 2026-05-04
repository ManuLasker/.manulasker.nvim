-- ============================================================
-- Harpoon: Project file bookmarks for fast navigation
-- ============================================================
-- Mark 4 files you're actively working on, jump between them
-- with single keystrokes. Per-project (each project has its own marks).
-- Repo: github.com/ThePrimeagen/harpoon (branch: harpoon2)

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",

    keys = {
        -- ── Add file to harpoon list ────────────────────────
        { "<leader>ha", function()
            require("harpoon"):list():add()
        end, desc = "Harpoon: add file" },

        -- ── Toggle harpoon menu ─────────────────────────────
        { "<C-e>", function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, desc = "Harpoon: toggle menu" },

        -- ── Jump to file by index (QWERTY home row) ─────────
        { "<C-h>", function() require("harpoon"):list():select(1) end,
            desc = "Harpoon: file 1" },
        { "<C-j>", function() require("harpoon"):list():select(2) end,
            desc = "Harpoon: file 2" },
        { "<C-k>", function() require("harpoon"):list():select(3) end,
            desc = "Harpoon: file 3" },
        { "<C-l>", function() require("harpoon"):list():select(4) end,
            desc = "Harpoon: file 4" },
        -- ── Cycle through harpoon list ──────────────────────
        { "<leader>hP", function() require("harpoon"):list():prev() end,
            desc = "Harpoon: prev file" },
        { "<leader>hN", function() require("harpoon"):list():next() end,
            desc = "Harpoon: next file" },
    },

    config = function()
        local harpoon = require("harpoon")

        harpoon:setup({
            settings = {
                save_on_toggle = true,
                sync_on_ui_close = true,
                key = function()
                    -- One harpoon list per project (cwd-based)
                    return vim.loop.cwd()
                end,
            },
        })

    end,
}
