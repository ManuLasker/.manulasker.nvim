-- ============================================================
-- Colorscheme: Catppuccin Mocha
-- ============================================================
-- Why Catppuccin:
--   - Coherent with Waybar/Mako/Alacritty (rest of system)
--   - Excellent LSP/Treesitter integration
--   - Active maintenance and integrations with major plugins
-- Repo: github.com/catppuccin/nvim

return {
    "catppuccin/nvim",
    name = "catppuccin",        -- override default name (would be "nvim")
    priority = 1000,            -- load BEFORE all other plugins (highest priority)
    lazy = false,               -- load on startup, not lazy
    config = function()
        require("catppuccin").setup({
            -- ── Flavour ─────────────────────────────────────
            -- Available: latte (light), frappe, macchiato, mocha (darkest)
            flavour = "mocha",

            -- ── Background ──────────────────────────────────
            background = {
                light = "latte",
                dark = "mocha",
            },

            -- ── Transparency ────────────────────────────────
            -- Set true if you want to see Alacritty's transparency through nvim
            transparent_background = true,

            -- ── Visual Tweaks ───────────────────────────────
            show_end_of_buffer = false,    -- don't show ~ on empty lines
            term_colors = true,            -- set terminal colors when using :terminal
            dim_inactive = {
                enabled = false,           -- don't dim inactive splits
                shade = "dark",
                percentage = 0.15,
            },
            no_italic = false,             -- allow italics
            no_bold = false,               -- allow bold
            no_underline = false,          -- allow underline

            -- ── Style overrides per syntax category ─────────
            styles = {
                comments = { "italic" },       -- comments in italic
                conditionals = { "italic" },   -- if/else/etc. in italic
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
            },

            -- ── Color overrides ─────────────────────────────
            -- Override specific colors if you want (we keep defaults)
            color_overrides = {},

            -- ── Custom highlight overrides ──────────────────
            -- Override how specific syntax elements look
            custom_highlights = function(colors)
                return {
                    -- Example: make line numbers more visible
                    LineNr = { fg = colors.overlay0 },
                    CursorLineNr = { fg = colors.lavender, style = { "bold" } },

                    -- Make floating windows have a subtle border
                    FloatBorder = { fg = colors.blue, bg = colors.base },
                }
            end,

            -- ── Plugin Integrations ─────────────────────────
            -- Enable theme support for plugins as we install them
            -- We can add more here as we add plugins
            integrations = {
                cmp = true,                -- nvim-cmp (completion)
                gitsigns = true,           -- gitsigns
                nvimtree = false,          -- not using nvim-tree
                neotree = true,            -- using neo-tree
                treesitter = true,         -- treesitter
                notify = true,             -- nvim-notify
                mini = {
                    enabled = true,
                    indentscope_color = "",
                },
                telescope = {
                    enabled = true,
                },
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                    },
                    underlines = {
                        errors = { "underline" },
                        hints = { "underline" },
                        warnings = { "underline" },
                        information = { "underline" },
                    },
                    inlay_hints = {
                        background = true,
                    },
                },
                mason = true,
                which_key = true,
                indent_blankline = {
                    enabled = true,
                    scope_color = "",
                    colored_indent_levels = false,
                },
                harpoon = true,
                markdown = true,
                noice = false,
                bufferline = true,
            },
        })

        -- ── Apply the colorscheme ───────────────────────────
        -- Must be called AFTER setup()
        vim.cmd.colorscheme("catppuccin")
    end,
}
