-- ============================================================
-- Treesitter: Modern syntax highlighting & code analysis
-- ============================================================
-- Neovim 0.12+ migration — uses the new `main` branch API.
--
-- The old `master` branch and `nvim-treesitter.configs` module
-- are obsolete and not compatible with Neovim 0.12.
--
-- Key changes from old setup:
--   - Branch changed from `master` to `main`
--   - `nvim-treesitter.configs` no longer exists
--   - Highlighting/indent enabled via FileType autocmd
--   - `ensure_installed` replaced with manual install API
--   - tree-sitter CLI required for compiling parsers
--
-- Install tree-sitter CLI first:
--   cargo install tree-sitter-cli
--   or: npm install -g tree-sitter-cli
--
-- After changing branch, run in order:
--   :Lazy update nvim-treesitter  (then press x in UI to remove old)
--   :TSUninstall all
--   restart Neovim
--   :TSUpdate
--   :checkhealth nvim-treesitter
--
-- Repo: github.com/nvim-treesitter/nvim-treesitter (main branch)
-- ============================================================

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",   -- nueva rama para 0.12
  build  = ":TSUpdate",
  event  = { "BufReadPost", "BufNewFile" },
  dependencies = {
    { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
  },
  init = function()
    -- ── Instalar parsers necesarios ──────────────────
    local ensure_installed = {
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
    }
    local already = require("nvim-treesitter.config").get_installed()
    local to_install = vim.iter(ensure_installed)
    :filter(function(p) return not vim.tbl_contains(already, p) end)
    :totable()
    if #to_install > 0 then
      require("nvim-treesitter").install(to_install)
    end

    -- ── Highlight + indent via FileType autocmd ───────
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local ft = vim.bo[args.buf].filetype
        -- skip problematic filetypes
        if ft == "" or ft == "codecompanion" then return end
        pcall(vim.treesitter.start, args.buf)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    -- ── Folding ───────────────────────────────────────
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr   = "v:lua.vim.treesitter.foldexpr()"
    vim.opt.foldenable = false
  end,
}
