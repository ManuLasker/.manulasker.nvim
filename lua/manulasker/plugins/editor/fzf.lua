-- ============================================================
-- fzf-lua: Fast fuzzy finder (fzf wrapper for Neovim)
-- ============================================================
-- Replaces Telescope with a faster, more responsive picker.
-- Uses the fzf binary (C/Go) for filtering — much faster than pure Lua.
-- Repo: github.com/ibhagwan/fzf-lua

return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",  -- load when :FzfLua is called

    keys = {
        -- ── File pickers ────────────────────────────────────
        { "<leader>pf", "<cmd>FzfLua files<cr>",
            desc = "Find files in project" },
        { "<leader>pF", function()
            require("fzf-lua").files({ cmd = "fd --type f --hidden --no-ignore" })
        end, desc = "Find files (including hidden + ignored)" },
        { "<C-p>", "<cmd>FzfLua git_files<cr>",
            desc = "Find git tracked files" },

        -- ── Text search (live grep) ─────────────────────────
        { "<leader>ps", "<cmd>FzfLua live_grep<cr>",
            desc = "Search text in project (grep)" },
        { "<leader>pw", "<cmd>FzfLua grep_cword<cr>",
            desc = "Search current word in project" },
        { "<leader>pW", "<cmd>FzfLua grep_cWORD<cr>",
            desc = "Search current WORD in project" },

        -- ── Buffer / help / commands ────────────────────────
        { "<leader>pb", "<cmd>FzfLua buffers<cr>",
            desc = "Find open buffers" },
        { "<leader>ph", "<cmd>FzfLua help_tags<cr>",
            desc = "Search help docs" },
        { "<leader>pk", "<cmd>FzfLua keymaps<cr>",
            desc = "Search keymaps" },
        { "<leader>pc", "<cmd>FzfLua commands<cr>",
            desc = "Search commands" },
        { "<leader>p:", "<cmd>FzfLua command_history<cr>",
            desc = "Command history" },
        { "<leader>p/", "<cmd>FzfLua search_history<cr>",
            desc = "Search history" },

        -- ── Git ─────────────────────────────────────────────
        { "<leader>gc", "<cmd>FzfLua git_commits<cr>",
            desc = "Git commits" },
        { "<leader>gb", "<cmd>FzfLua git_bcommits<cr>",
            desc = "Git buffer commits (current file)" },
        { "<leader>gs", "<cmd>FzfLua git_status<cr>",
            desc = "Git status" },

        -- ── Misc ────────────────────────────────────────────
        { "<leader>pr", "<cmd>FzfLua resume<cr>",
            desc = "Resume last picker" },
        { "<leader>pd", "<cmd>FzfLua diagnostics_workspace<cr>",
            desc = "Diagnostics (LSP errors/warnings)" },
        { "<leader>po", "<cmd>FzfLua oldfiles<cr>",
            desc = "Recently opened files" },
        { "<leader>pl", "<cmd>FzfLua lines<cr>",
            desc = "Search lines in current buffer" },
    },

    config = function()
        local fzf = require("fzf-lua")

        fzf.setup({
            -- ── Use the "default" profile as base ───────────
            -- Other profiles: "max-perf", "telescope", "fzf-vim", "fzf-native"
            -- "default" gives us a balance of features and speed
            "default",

            -- ── Window appearance ───────────────────────────
            winopts = {
                height = 0.85,                    -- 85% of screen height
                width = 0.85,                     -- 85% of screen width
                row = 0.35,                       -- vertical position (0=top, 1=bottom)
                col = 0.50,                       -- horizontal center
                border = "rounded",               -- match catppuccin style
                backdrop = 60,                    -- dim background (0-100)
                preview = {
                    border = "rounded",
                    layout = "horizontal",        -- preview to the right of results
                    horizontal = "right:55%",     -- preview takes 55% width
                    scrollbar = "float",
                    delay = 100,                  -- ms before preview loads
                },
            },

            -- ── Key bindings inside fzf window ──────────────
            keymap = {
                builtin = {
                    -- Inside fzf, in normal mode (rare, you stay in fzf mode)
                    ["<F1>"] = "toggle-help",
                    ["<F2>"] = "toggle-fullscreen",
                    ["<F3>"] = "toggle-preview-wrap",
                    ["<F4>"] = "toggle-preview",
                    ["<C-d>"] = "preview-page-down",
                    ["<C-u>"] = "preview-page-up",
                },
                fzf = {
                    -- These work inside the fzf prompt (always)
                    ["ctrl-q"] = "accept",   -- send all to quickfix
                    ["ctrl-d"] = "preview-page-down",
                    ["ctrl-u"] = "preview-page-up",
                },
            },

            -- ── File picker ─────────────────────────────────
            files = {
                prompt = "Files❯ ",
                multiprocess = true,                 -- faster on large projects
                git_icons = true,                    -- show git status icons
                file_icons = true,                   -- file type icons
                color_icons = true,
                -- Use fd if available, fall back to find
                fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude node_modules",
            },

            -- ── Live grep ───────────────────────────────────
            grep = {
                prompt = "Grep❯ ",
                input_prompt = "Grep For❯ ",
                multiprocess = true,
                git_icons = true,
                file_icons = true,
                color_icons = true,
                rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden --glob '!.git/'",
            },

            -- ── Buffers ─────────────────────────────────────
            buffers = {
                prompt = "Buffers❯ ",
                file_icons = true,
                color_icons = true,
                sort_lastused = true,
                actions = {
                    ["ctrl-x"] = { fn = require("fzf-lua").actions.buf_del, reload = true },
                },
            },

            -- ── Git ─────────────────────────────────────────
            git = {
                files = {
                    prompt = "GitFiles❯ ",
                    cmd = "git ls-files --exclude-standard",
                    multiprocess = true,
                    git_icons = true,
                    file_icons = true,
                    color_icons = true,
                },
                status = {
                    prompt = "GitStatus❯ ",
                    file_icons = true,
                    git_icons = true,
                    color_icons = true,
                },
                commits = {
                    prompt = "Commits❯ ",
                    preview = "git show --color {1}",
                },
                branches = {
                    prompt = "Branches❯ ",
                },
            },
        })
    end,
}
