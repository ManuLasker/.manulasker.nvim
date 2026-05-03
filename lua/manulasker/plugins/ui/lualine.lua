-- ============================================================
-- Lualine: Statusline at the bottom of Neovim
-- ============================================================
-- Replaces the default vim statusline with a configurable, themed one.
-- Shows: mode | branch | filename | diagnostics | filetype | progress | location
-- Repo: github.com/nvim-lualine/lualine.nvim

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },  -- file icons
    event = "VeryLazy",  -- load after startup (UI doesn't need to be there immediately)
    config = function()
        require("lualine").setup({
            options = {
                -- ── Theme ───────────────────────────────────
                theme = "auto",      -- match colorscheme
                icons_enabled = true,

                -- ── Separators ──────────────────────────────
                -- Between sections (left/right edges of each section)
                section_separators = { left = "", right = "" },
                -- Between components within a section
                component_separators = { left = "", right = "" },

                -- ── Behavior ────────────────────────────────
                globalstatus = true,         -- one statusline for all splits (cleaner)
                always_divide_middle = true,
                refresh = {
                    statusline = 1000,       -- refresh every 1s
                    tabline = 1000,
                    winbar = 1000,
                },

                -- ── Disabled in these filetypes ─────────────
                disabled_filetypes = {
                    statusline = { "alpha", "dashboard" },
                    winbar = {},
                },
            },

            -- ── Section Layout ──────────────────────────────
            -- Statusline is divided in sections a/b/c (left) and x/y/z (right)
            -- a: most prominent (shows mode)
            -- b: secondary info (branch)
            -- c: tertiary info (filename, diagnostics)
            -- x/y/z: same but on the right
            sections = {
                lualine_a = {
                    {
                        "mode",
                        fmt = function(str) return str:sub(1, 3) end,  -- abbreviate "NORMAL" → "NOR"
                    },
                },
                lualine_b = {
                    "branch",
                    {
                        "diff",
                        symbols = { added = " ", modified = " ", removed = " " },
                    },
                },
                lualine_c = {
                    {
                        "filename",
                        path = 1,  -- 0=name only, 1=relative, 2=absolute, 3=absolute~
                        symbols = {
                            modified = " ●",
                            readonly = " ",
                            unnamed = "[No Name]",
                            newfile = "[New]",
                        },
                    },
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        symbols = { error = " ", warn = " ", info = " ", hint = " " },
                    },
                },
                lualine_x = {
                    "encoding",
                    {
                        "fileformat",
                        symbols = { unix = "", dos = "", mac = "" },
                    },
                    "filetype",
                },
                lualine_y = { "progress" },  -- 50% (where in file)
                lualine_z = { "location" },  -- line:col
            },

            -- ── Inactive splits (greyed out) ────────────────
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },

            -- ── Tabline (top tabs) ──────────────────────────
            -- Disabled — bufferline plugin will handle tabs better later
            tabline = {},
            winbar = {},
            inactive_winbar = {},

            extensions = {
                "neo-tree",
                "lazy",
                "mason",
                "trouble",
                "quickfix",
            },
        })
    end,
}
