-- ============================================================
-- Keymaps
-- ============================================================
-- Convention:
--   <leader>  = Space
--   "n"       = normal mode
--   "v"       = visual mode (excluding select)
--   "x"       = visual mode only (no select)
--   "i"       = insert mode
--   "t"       = terminal mode
--   {"n","v"} = both normal and visual
-- ============================================================

-- Set leader BEFORE any keymap that uses it
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ── File Explorer ───────────────────────────────────────────
-- Ex = netrw built-in file explorer (no plugin needed)
-- TODO: when neo-tree is configured, this might be replaced
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex,
    { desc = "Open netrw file explorer" })

-- ── Move Lines (visual mode) ────────────────────────────────
-- Select lines in visual mode, then J/K to move them down/up
-- Auto-reindents after move (gv=gv)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv",
{ desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv",
{ desc = "Move selected lines up" })

-- ── Smart Join ──────────────────────────────────────────────
-- J normally joins lines but moves cursor — this keeps cursor in place
-- mz = mark position, J = join, `z = return to mark
vim.keymap.set("n", "J", "mzJ`z",
    { desc = "Join lines without moving cursor" })

-- ── Half-page Scroll Centered ───────────────────────────────
-- Default <C-d>/<C-u> scrolls but cursor can end up at edges
-- Adding zz centers screen on cursor after scroll
vim.keymap.set("n", "<C-d>", "<C-d>zz",
    { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz",
    { desc = "Half page up (centered)" })

-- ── Search Centered ─────────────────────────────────────────
-- n/N jumps to next/prev match — zz centers, zv opens folds
vim.keymap.set("n", "n", "nzzzv",
    { desc = "Next search match (centered)" })
vim.keymap.set("n", "N", "Nzzzv",
    { desc = "Prev search match (centered)" })

-- ── Increment / Decrement Numbers ───────────────────────────
-- Vim defaults: <C-a> = increment, <C-x> = decrement
-- But <C-a> conflicts with tmux prefix, so remap to <C-b>
-- IMPORTANT: <C-x> stays as decrement (no conflict)
vim.keymap.set({ "n", "v" }, "<C-b>", "<C-a>",
    { desc = "Increment number (tmux-safe)" })
vim.keymap.set({ "n", "v" }, "g<C-b>", "g<C-a>",
    { desc = "Increment sequence in visual selection" })

-- ── Greatest Remap Ever (Prime classic) ─────────────────────
-- When you paste over selected text, Vim normally yanks the deleted text
-- This sends deleted text to black hole register so your paste stays available
vim.keymap.set("x", "<leader>p", [["_dP]],
    { desc = "Paste without losing yank" })

-- ── System Clipboard (asbjornHaland classic) ────────────────
-- <leader>y → yank to system clipboard (works with wl-clipboard on Wayland)
-- <leader>Y → yank entire line to system clipboard
-- <leader>d → delete without affecting any register
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]],
    { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]],
    { desc = "Yank line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]],
    { desc = "Delete without yanking" })

-- ── Insert Mode Escape Alternative ──────────────────────────
-- <C-c> doesn't trigger InsertLeave autocmds reliably
-- This makes <C-c> behave exactly like <Esc>
vim.keymap.set("i", "<C-c>", "<Esc>",
    { desc = "Escape (autocmd-safe)" })

-- ── Search and Replace Word Under Cursor ────────────────────
-- <leader>s → replace word under cursor globally (interactive)
vim.keymap.set("n", "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace word under cursor (case-sensitive)" })

-- <leader>* → replace word under cursor (no confirm)
vim.keymap.set("n", "<leader>*",
    [[:%s/\<<C-r><C-w>\>//g<Left><Left>]],
    { desc = "Replace word under cursor globally" })

-- <leader>& → replace word under cursor (with confirm prompt)
vim.keymap.set("n", "<leader>&",
    [[:%s/\<<C-r><C-w>\>//gc<Left><Left><Left>]],
    { desc = "Replace word under cursor (confirm each)" })

-- ── Disable Q (Ex mode is useless) ──────────────────────────
-- Q normally enters Ex mode which nobody uses and is annoying
vim.keymap.set("n", "Q", "<nop>",
    { desc = "Disable Ex mode" })

-- ── Tmux Sessionizer (Prime classic) ────────────────────────
-- Opens tmux-sessionizer in new tmux window for fast project switching
-- Requires: ~/.local/bin/tmux-sessionizer script (see Prime's dotfiles)
-- vim.keymap.set("n", "<C-f>",
--     "<cmd>silent !tmux neww tmux-sessionizer<CR>",
--     { desc = "Tmux sessionizer (fast project switch)" })

-- ── Make File Executable ────────────────────────────────────
-- Quick way to chmod +x current file (great for shell scripts)
vim.keymap.set("n", "<leader>x",
    "<cmd>!chmod +x %<CR>",
    { silent = true, desc = "Make current file executable" })

-- ── Window Resize Mode ──────────────────────────────────────
-- Enter resize mode with <leader>r, then use hjkl to resize
-- Press <Esc> or q to exit resize mode
vim.keymap.set("n", "<leader>r", function()
    print("-- RESIZE MODE -- (h/j/k/l = resize | q/Esc = exit)")
    while true do
        local ok, key = pcall(vim.fn.getcharstr)
        if not ok or key == "\27" or key == "q" then  -- Esc or q
            print("")
            break
        elseif key == "h" then
            vim.cmd("vertical resize -5")
        elseif key == "j" then
            vim.cmd("resize -5")
        elseif key == "k" then
            vim.cmd("resize +5")
        elseif key == "l" then
            vim.cmd("vertical resize +5")
        end
        vim.cmd("redraw")
    end
end, { desc = "Enter window resize mode" })


-- ── Quickfix / Location List Navigation (moved to leader) ──
-- Quickfix list — global, used by grep, LSP errors, etc.
vim.keymap.set("n", "<leader>cn", "<cmd>cnext<CR>zz",
    { desc = "Next quickfix item" })
vim.keymap.set("n", "<leader>cp", "<cmd>cprev<CR>zz",
    { desc = "Prev quickfix item" })
vim.keymap.set("n", "<leader>co", "<cmd>copen<CR>",
    { desc = "Open quickfix list" })
vim.keymap.set("n", "<leader>cc", "<cmd>cclose<CR>",
    { desc = "Close quickfix list" })

-- Location list — buffer-local list (like quickfix but per-window)
vim.keymap.set("n", "<leader>ln", "<cmd>lnext<CR>zz",
    { desc = "Next location list item" })
vim.keymap.set("n", "<leader>lp", "<cmd>lprev<CR>zz",
    { desc = "Prev location list item" })

-- ── Buffer Navigation ───────────────────────────────────────
-- Cycle through open buffers with Shift+h/l
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>",
    { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>",
    { desc = "Prev buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>",
    { desc = "Delete buffer" })

-- ── Better Indenting (visual mode) ──────────────────────────
-- Stay in visual mode after indenting (so you can indent multiple times)
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- ── Clear Search Highlight ──────────────────────────────────
-- Even though hlsearch is off, sometimes it gets toggled
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>",
    { desc = "Clear search highlight" })

-- ── Terminal Mode Escape ────────────────────────────────────
-- Inside :terminal, <Esc> doesn't work normally
-- Use <Esc><Esc> to exit terminal mode (back to normal)
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>",
    { desc = "Exit terminal mode" })
