-- ────────────────────────────────────────────────────────
-- Mason: package manager for LSP servers, DAP, linters, formatters
-- ────────────────────────────────────────────────────────
return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  keys = {
    { "<leader>cm", "<cmd>Mason<cr>", desc = "Open Mason UI" },
  },
  build = ":MasonUpdate",
  opts = {
    ui = {
      border = "rounded",
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  },
}
