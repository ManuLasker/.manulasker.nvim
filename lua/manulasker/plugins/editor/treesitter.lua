-- ============================================================
-- Treesitter: Modern syntax highlighting & code analysis
-- ============================================================
-- Parses code into an AST (Abstract Syntax Tree) for:
--   - Better syntax highlighting (semantic, not regex-based)
--   - Smart indentation
--   - Code folding
--   - Text objects (select/operate on functions, classes, etc.)
--   - Incremental selection
-- Repo: github.com/nvim-treesitter/nvim-treesitter

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",                    -- main branch (more stable than nightly)
    build = ":TSUpdate",                  -- run :TSUpdate after install
    event = { "BufReadPost", "BufNewFile" },   -- load when opening any file

    dependencies = {
        -- Additional text objects (vif = visual inside function, etc.)
        "nvim-treesitter/nvim-treesitter-textobjects",
    },

    config = function()
        require("nvim-treesitter.configs").setup({
            -- ── Languages to install/keep installed ─────────
            -- "all" installs every parser (slow, big disk usage)
            -- We pick the languages you actually use
            ensure_installed = {
                -- Web
                "javascript", "typescript", "tsx",
                "html", "css", "scss",
                "json", "jsonc", "yaml", "toml",

                -- Backend
                "python", "java", "go", "rust",
                "c", "cpp",

                -- Scripting / Config
                "lua", "vim", "vimdoc",
                "bash", "fish",
                "regex", "query",

                -- Docs
                "markdown", "markdown_inline",

                -- DevOps
                "dockerfile",
                "gitignore", "gitcommit", "git_rebase",
                "diff",

                -- Misc
                "comment",          -- highlights TODO, FIXME, NOTE in comments
                "sql",
            },

            -- ── Auto-install missing parsers when entering buffer ──
            auto_install = true,

            -- ── Sync vs async install ───────────────────────
            sync_install = false,   -- install async (faster startup)

            -- ── Highlighting ────────────────────────────────
            highlight = {
                enable = true,
                -- Disable for huge files (treesitter can be slow)
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024  -- 100KB
                    local ok, stats = pcall(vim.loop.fs_stat,
                        vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
                additional_vim_regex_highlighting = false,
            },

            -- ── Smart indentation ───────────────────────────
            -- Replaces vim's regex-based indent with AST-aware indent
            indent = {
                enable = true,
                -- Some languages have buggy indent, disable per-language if needed
                disable = { "yaml" },   -- yaml indent is fragile
            },

            -- ── Incremental selection ───────────────────────
            -- Press keymap to expand selection to next AST node
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",     -- start selection
                    node_incremental = "<C-space>",   -- expand to next node
                    scope_incremental = "<C-s>",      -- expand to scope
                    node_decremental = "<bs>",        -- shrink (backspace)
                },
            },

            -- ── Text objects (from treesitter-textobjects) ──
            -- Adds vim text objects based on AST nodes
            -- Examples: vaf = visual around function, vac = visual around class
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,   -- jump forward to find textobject
                    keymaps = {
                        -- Functions
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        -- Classes
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        -- Parameters
                        ["aa"] = "@parameter.outer",
                        ["ia"] = "@parameter.inner",
                        -- Conditionals
                        ["ai"] = "@conditional.outer",
                        ["ii"] = "@conditional.inner",
                        -- Loops
                        ["al"] = "@loop.outer",
                        ["il"] = "@loop.inner",
                        -- Comments
                        ["a/"] = "@comment.outer",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,   -- add jumps to jumplist
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer",
                    },
                    goto_next_end = {
                        ["]F"] = "@function.outer",
                        ["]C"] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer",
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                        ["[C"] = "@class.outer",
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>na"] = "@parameter.inner",   -- swap parameter with next
                    },
                    swap_previous = {
                        ["<leader>pa"] = "@parameter.inner",   -- swap parameter with prev
                    },
                },
            },
        })

        -- ── Folding setup (optional but useful) ─────────────
        -- Use treesitter for code folding (smarter than indent-based)
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        vim.opt.foldenable = false   -- don't fold by default (toggle with zc)
    end,
}
