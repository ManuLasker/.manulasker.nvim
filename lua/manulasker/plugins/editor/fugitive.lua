-- ============================================================
-- Fugitive: Git wrapper by Tim Pope
-- ============================================================
-- The classic minimal git integration for vim.
-- Provides :Git command that opens an interactive git status buffer
-- where you can stage, unstage, commit, diff, etc.
-- Repo: github.com/tpope/vim-fugitive

return {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiff", "Gblame", "Glog", "Gstatus", "Gwrite", "Gread" },

    keys = {
        { "<leader>gS", vim.cmd.Git, desc = "Open Git status (fugitive)" },
        { "<leader>gB", "<cmd>Git blame<cr>", desc = "Git blame (fugitive)" },
        { "<leader>gL", "<cmd>Git log --oneline<cr>", desc = "Git log (fugitive)" },
    },

    config = function()
        -- ── Buffer-local keymaps inside :Git buffer ─────────
        -- These only apply when you're INSIDE the fugitive status buffer
        local fugitive_group = vim.api.nvim_create_augroup(
            "manulasker_fugitive", { clear = true }
        )

        vim.api.nvim_create_autocmd("BufWinEnter", {
            group = fugitive_group,
            pattern = "*",
            callback = function()
                -- Only apply if we're in a fugitive buffer
                if vim.bo.ft ~= "fugitive" then
                    return
                end


                local bufnr = vim.api.nvim_get_current_buf()
                local opts = { buffer = bufnr, remap = false }

                -- ── Push ────────────────────────────────────
                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git("push")
                end, vim.tbl_extend("force", opts, { desc = "Git push" }))

                -- ── Pull with rebase (preferred for clean history) ──
                vim.keymap.set("n", "<leader>P", function()
                    vim.cmd.Git({ "pull", "--rebase" })
                end, vim.tbl_extend("force", opts, { desc = "Git pull --rebase" }))

                -- ── Set upstream branch (handy for new branches) ──
                -- Cursor stops at end so you can type the branch name
                vim.keymap.set("n", "<leader>t", ":Git push -u origin ",
                    vim.tbl_extend("force", opts, { desc = "Git push -u origin <branch>" }))
            end,
            desc = "Set fugitive buffer-local keymaps",
        })
    end,
}
