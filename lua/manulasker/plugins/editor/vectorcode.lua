-- ============================================================
-- VectorCode: Codebase indexing for AI context
-- ============================================================
-- Install CLI first:
--   uv tool install vectorcode
--
-- Index a project:
--   cd ~/my-project && vectorcode vectorise
--
-- Update index:
--   vectorcode update
--
-- Check status:
--   vectorcode ls
-- ============================================================
return {
    "Davidyz/VectorCode",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = true,
}
