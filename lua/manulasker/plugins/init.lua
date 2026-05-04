-- ============================================================
-- Plugin specs entry point
-- ============================================================
-- This file tells Lazy.nvim to import all plugin files from
-- the subdirectories (ui/, editor/, lsp/, tools/).
--
-- Each subdirectory file should return a plugin spec table.

return {
    { import = "manulasker.plugins.ui" },
    { import = "manulasker.plugins.editor" },
    { import = "manulasker.plugins.lsp" },
}
