-- ============================================================
-- Editor Settings
-- ============================================================

-- ── UI / Display ────────────────────────────────────────────
vim.opt.guicursor = "a:block-blinkwait175-blinkoff150-blinkon175"  -- Blinking block in all modes
vim.opt.number = true               -- Show line number on current line
vim.opt.relativenumber = true       -- Other lines show distance from current (great for motions like 5j, 12k)
vim.opt.cursorline = true           -- Highlight the entire current line
vim.opt.cursorcolumn = true         -- Highlight the entire current column
vim.opt.colorcolumn = "80"          -- Vertical ruler at column 80 (visual reminder for line length)
vim.opt.scrolloff = 8               -- Keep 8 lines visible above/below cursor when scrolling
vim.opt.signcolumn = "yes"          -- Always show sign column on left (LSP errors, git signs) — prevents text shift
vim.opt.termguicolors = true        -- Enable 24-bit RGB colors (required for modern themes)
vim.opt.wrap = false                -- Don't wrap long lines — they extend off-screen instead
vim.opt.showmode = false            -- Don't show "-- INSERT --" at bottom (lualine shows it)

-- ── Indentation (defaults — overridden per filetype in autocmds.lua) ──
vim.opt.tabstop = 4                 -- A tab character is displayed as 4 spaces wide
vim.opt.softtabstop = 4             -- Pressing Tab in insert mode inserts 4 spaces of indentation
vim.opt.shiftwidth = 4              -- Auto-indent operations (>>, <<, ==) use 4 spaces
vim.opt.expandtab = true            -- Convert tab keypresses into spaces (no actual \t character)
vim.opt.autoindent = true
vim.opt.smartindent = false         -- Auto-indent new lines based on syntax  (false this breaks in lua)

-- ── Search ──────────────────────────────────────────────────
vim.opt.hlsearch = false            -- Don't keep highlighting matches after search ends
vim.opt.incsearch = true            -- Highlight matches incrementally as you type
vim.opt.ignorecase = true           -- Case-insensitive search by default
vim.opt.smartcase = true            -- ...but case-sensitive if query has uppercase letters

-- ── Files / History ─────────────────────────────────────────
vim.opt.swapfile = false            -- Don't create .swp files (avoids "file already in use" warnings)
vim.opt.backup = false              -- Don't create backup files before writing
vim.opt.undofile = true             -- Save undo history to disk (persists across sessions)
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"  -- Where undo files are stored

-- ── Performance ─────────────────────────────────────────────
vim.opt.updatetime = 50             -- Faster CursorHold events (default 4000ms) — affects LSP hover, gitsigns

-- ── Splits ──────────────────────────────────────────────────
vim.opt.splitbelow = true           -- New horizontal splits (:split) appear below current window
vim.opt.splitright = true           -- New vertical splits (:vsplit) appear to the right of current window

-- ── Misc ────────────────────────────────────────────────────
vim.opt.isfname:append("@-@")       -- Allow @ in filename detection (useful for `gf` (go to file) to follow file paths)

-- NOTE: Mouse and clipboard intentionally NOT set
-- Mouse: stay keyboard-only (vim philosophy — no mouse interaction)
-- Clipboard: handled manually via <leader>y to wl-copy in remap.lua
--   (instead of `clipboard = "unnamedplus"` which would auto-sync everything,
--    we keep system clipboard separate and only push when explicitly requested)
