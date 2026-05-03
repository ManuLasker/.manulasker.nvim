-- ============================================================
-- Undotree: Visual undo history as a tree
-- ============================================================
-- Vim's undo is a tree, not a linear stack.
-- This plugin visualizes that tree so you can navigate any past state.
-- Repo: github.com/mbbill/undotree

return {
    "mbbill/undotree",
    cmd = "UndotreeToggle",   -- load when :UndotreeToggle is called

    keys = {
        { "<leader>u", "<cmd>UndotreeToggle<cr>",
            desc = "Toggle undotree" },
    },

    config = function()
        -- ── Layout ──────────────────────────────────────────
        -- 1 = right panel, no diff window
        -- 2 = right panel + diff window below
        -- 3 = right panel + diff window left of editor
        -- 4 = right panel + diff window in middle
        vim.g.undotree_WindowLayout = 2

        -- ── Width of the undotree panel ─────────────────────
        vim.g.undotree_SplitWidth = 35

        -- ── Width of the diff window ────────────────────────
        vim.g.undotree_DiffpanelHeight = 10

        -- ── Auto-open the diff window when undotree opens ───
        vim.g.undotree_DiffAutoOpen = 1

        -- ── Set focus to undotree when opened ───────────────
        vim.g.undotree_SetFocusWhenToggle = 1

        -- ── Show short file timestamps ──────────────────────
        vim.g.undotree_ShortIndicators = 1

        -- ── Highlight changes ───────────────────────────────
        vim.g.undotree_HighlightChangedText = 1

        -- ── Help text at top of undotree panel ──────────────
        vim.g.undotree_HelpLine = 1
    end,
}
