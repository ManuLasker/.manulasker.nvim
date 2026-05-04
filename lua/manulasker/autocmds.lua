-- ============================================================
-- Autocommands & Global Helpers
-- ============================================================

-- ── Helper Functions ────────────────────────────────────────
-- Reload a Lua module without restarting Neovim
-- Usage: :lua R("manulasker.set")
function R(name)
  require("plenary.reload").reload_module(name)
end

-- ── Augroup ─────────────────────────────────────────────────
local augroup = vim.api.nvim_create_augroup("manulasker", { clear = true })

-- ── Indentation per filetype ────────────────────────────────
-- Languages that conventionally use 2 spaces
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = {
    "javascript", "javascriptreact",
    "typescript", "typescriptreact",
    "html", "css", "scss", "sass",
    "json", "jsonc", "yaml", "toml",
    "lua", "vue", "svelte",
    "ruby", "elixir",
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
  desc = "Use 2-space indentation for web/scripting languages",
})

-- Disable treesitter in codecompanion diff buffers
-- Workaround for neovim 0.12 treesitter bug with markdown fenced code blocks
-- See: https://github.com/neovim/neovim/issues/39032
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "codecompanion" },
    callback = function(args)
        vim.treesitter.stop(args.buf)
        vim.bo[args.buf].syntax = "markdown"
    end,
    desc = "Disable buggy treesitter for markdown in nvim 0.12",
})

-- Languages that conventionally use 4 spaces
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = {
    "python", "java", "kotlin",
    "c", "cpp", "rust",
    "php", "swift",
  },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
  desc = "Use 4-space indentation for backend/systems languages",
})

-- Go uses tabs (gofmt convention)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "go",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
  desc = "Go uses tabs (gofmt convention)",
})

-- Makefile REQUIRES tabs (parser requirement)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "make",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
  desc = "Makefiles require tabs",
})

-- ── Highlight Yanked Text ───────────────────────────────────
-- Visual flash when you yank — confirms what was copied
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 200,
    })
  end,
  desc = "Highlight yanked text briefly",
})

-- ── Trim Trailing Whitespace on Save ────────────────────────
-- Removes trailing spaces from every line before writing
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
  desc = "Trim trailing whitespace on save",
})

-- ── Restore Cursor Position ─────────────────────────────────
-- When opening a file, jump to where you left off last time
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Restore cursor to last position when opening file",
})

-- ── Disable Auto-Comment on New Line ────────────────────────
-- Don't auto-continue comments when pressing o/O on a comment line
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Don't auto-continue comments on new lines",
})

-- ── Close Special Buffers with q ────────────────────────────
-- Help, man pages, qf list, etc. — press q to close
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = {
    "help", "man", "qf", "lspinfo", "checkhealth",
    "spectre_panel", "startuptime", "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
  desc = "Close special buffers with q",
})

-- ── Equalize Splits on Window Resize ────────────────────────
-- If you resize the terminal, splits auto-equalize
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
  desc = "Equalize splits when terminal resizes",
})

-- ── Netrw Configuration ─────────────────────────────────────
-- These are global vars (not autocmds), but live here because
-- they configure netrw which is the file explorer used by <leader>pv
vim.g.netrw_browse_split = 0    -- Open files in same window
vim.g.netrw_banner = 0          -- Hide the banner at top
vim.g.netrw_winsize = 25        -- Use 25% of screen for netrw split
-- NOTE: Don't enable netrw_keepdir — it breaks Telescope and Harpoon
-- because it changes Neovim's working directory when navigating netrw
