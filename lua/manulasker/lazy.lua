-- ============================================================
-- Lazy.nvim Bootstrap & Setup
-- ============================================================
-- Plugin manager: github.com/folke/lazy.nvim

-- ── Bootstrap (install Lazy if not present) ─────────────────
-- Lazy installs itself in stdpath("data")/lazy/lazy.nvim
-- This is ~/.local/share/nvim/lazy/lazy.nvim on Linux
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    print("Installing lazy.nvim...")
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",            -- shallow clone, faster
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",               -- use stable releases
        lazypath,
    })
end

-- ── Add Lazy to runtime path ────────────────────────────────
-- This makes the lazy.nvim files findable by `require`
vim.opt.rtp:prepend(lazypath)

-- ── Setup Lazy.nvim ─────────────────────────────────────────
-- The "spec" (first argument) tells Lazy where to find plugin definitions
-- "manulasker.plugins" = lua/manulasker/plugins/ folder
-- Lazy automatically loads every .lua file in that folder recursively
require("lazy").setup("manulasker.plugins", {
    -- ── Lazy.nvim's own settings ────────────────────────────
    checker = {
        enabled = true,        -- check for plugin updates
        notify = false,        -- don't notify, just check silently
        frequency = 86400,     -- check once a day (in seconds)
    },
    change_detection = {
        enabled = true,        -- detect config changes and offer reload
        notify = false,        -- don't show "config changed" notifications
    },
    performance = {
        rtp = {
            -- Disable some default vim plugins we don't need
            -- (these are loaded by default but rarely useful)
            disabled_plugins = {
                "gzip",            -- gzip support
                "matchit",         -- treesitter handles this better
                "matchparen",      -- we'll use a plugin for this
                -- "netrwPlugin",     -- ⚠️ we use netrw via <leader>pv, keep enabled
                "tarPlugin",       -- tar support
                "tohtml",          -- :TOhtml command
                "tutor",           -- :Tutor command
                "zipPlugin",       -- zip support
            },
        },
    },
    ui = {
        border = "rounded",    -- rounded border for Lazy's popup
    },
})
