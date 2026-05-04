-- ============================================================
-- LSP: Mason + lspconfig + base configuration
-- ============================================================
-- Mason: installer for LSP servers, formatters, linters
-- lspconfig: bridge between Neovim's LSP client and language servers
-- mason-lspconfig: makes Mason and lspconfig work together
--
-- Servers themselves are configured in plugins/lsp/servers/*.lua
-- Each server file is loaded lazily based on filetype


return { }
