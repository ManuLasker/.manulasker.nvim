-- ────────────────────────────────────────────────────────
-- mason-lspconfig: bridge between Mason and lspconfig
-- ────────────────────────────────────────────────────────
return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim" },
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    ensure_installed = {
      -- Web (always loaded)
      "ts_ls",         -- TypeScript / JavaScript
      "html",          -- HTML
      "cssls",         -- CSS
      "tailwindcss",   -- Tailwind classes
      "emmet_ls",      -- HTML/CSS shortcuts
      "jsonls",        -- JSON

      -- Backend (lazy by filetype)
      "pyright",       -- Python
      "ruff",          -- Python linter (also LSP-capable)
      "gopls",         -- Go
      "rust_analyzer", -- Rust
      "clangd",        -- C / C++

      -- Config / scripting
      "lua_ls",        -- Lua (for editing nvim config!)
      "bashls",        -- Bash
      "yamlls",        -- YAML
      "taplo",         -- TOML
      "marksman",      -- Markdown

      -- DevOps
      "dockerls",      -- Dockerfile
      "docker_compose_language_service",

      -- "cmake"

    },
    automatic_installation = true,
  },
}
