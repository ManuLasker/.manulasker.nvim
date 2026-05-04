-- ────────────────────────────────────────────────────────
-- nvim-lspconfig: actual LSP setup
-- ────────────────────────────────────────────────────────
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- ── Diagnostics UI ──────────────────────────────
    -- Configure how errors/warnings appear in the editor
    vim.diagnostic.config({
      virtual_text = {
        prefix = "●",
        spacing = 2,
        severity = {
          min = vim.diagnostic.severity.HINT,
        },
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN]  = " ",
          [vim.diagnostic.severity.HINT]  = " ",
          [vim.diagnostic.severity.INFO]  = " ",
        },
      },
      update_in_insert = false,
      underline = true,
      severity_sort = true,
      float = {
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
      },
    })

    -- ── LSP attach: keymaps when LSP is active ──────
    -- Runs every time an LSP server attaches to a buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("manulasker_lsp_attach",
        { clear = true }),
      callback = function(event)
        local opts = function(desc)
          return { buffer = event.buf, desc = "LSP: " .. desc }
        end

        -- ── Navigation ──────────────────────────
        vim.keymap.set("n", "gd", vim.lsp.buf.definition,
          opts("Go to definition"))
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
          opts("Go to declaration"))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation,
          opts("Go to implementation"))
        vim.keymap.set("n", "gr", vim.lsp.buf.references,
          opts("Find references"))
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition,
          opts("Go to type definition"))

        -- ── Documentation ───────────────────────
        vim.keymap.set("n", "K", vim.lsp.buf.hover,
          opts("Hover documentation"))
        -- Signature help on <leader>lk to avoid Harpoon conflict on <C-k>
        vim.keymap.set({ "n", "i" }, "<leader>lk",
          vim.lsp.buf.signature_help,
          opts("Signature help"))

        -- ── Code actions ────────────────────────
        vim.keymap.set({ "n", "v" }, "<leader>la",
          vim.lsp.buf.code_action,
          opts("Code action"))
        vim.keymap.set("n", "<leader>lr",
          vim.lsp.buf.rename,
          opts("Rename symbol"))
        vim.keymap.set("n", "<leader>lf", function()
          vim.lsp.buf.format({ async = true })
        end, opts("Format buffer"))

        -- ── Diagnostics ─────────────────────────
        vim.keymap.set("n", "[d", function ()
          vim.diagnostic.jump({ count = -1, float = true })
        end,
          opts("Prev diagnostic"))
        vim.keymap.set("n", "]d", function ()
          vim.diagnostic.jump({ count = 1, float = true })
        end,
          opts("Next diagnostic"))
        vim.keymap.set("n", "<leader>ld",
          vim.diagnostic.open_float,
          opts("Show diagnostic"))
        vim.keymap.set("n", "<leader>lq",
          vim.diagnostic.setloclist,
          opts("Diagnostics to loclist"))

        -- ── Workspace ───────────────────────────
        vim.keymap.set("n", "<leader>lwa",
          vim.lsp.buf.add_workspace_folder,
          opts("Add workspace folder"))
        vim.keymap.set("n", "<leader>lwr",
          vim.lsp.buf.remove_workspace_folder,
          opts("Remove workspace folder"))
        vim.keymap.set("n", "<leader>lwl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts("List workspace folders"))
      end,
    })

    -- ── Default capabilities (extended by cmp later) ──
    -- nvim-cmp will extend these when we configure completion
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- ── Server-specific configurations ──────────────
    -- Each entry overrides defaults for that server
    -- Servers NOT listed here use the default config
    local servers = {
      -- add config per programming language in
      lua_ls = require("manulasker.plugins.lsp.servers.lua_ls"),
      clangd = require("manulasker.plugins.lsp.servers.clangd"),
      gopls = require("manulasker.plugins.lsp.servers.gopls"),
      ts_ls = require("manulasker.plugins.lsp.servers.ts_ls"),
      yamlls = require("manulasker.plugins.lsp.servers.yamlls")
    }

    -- ── Setup servers with custom config ────────────
    for server_name, server_opts in pairs(servers) do
      server_opts.capabilities = capabilities
      vim.lsp.config(server_name,  server_opts)
    end

    -- ── Setup all other installed servers with defaults ──
    -- mason-lspconfig v2 doesn't auto-setup servers, we do it manually
    local mason_lspconfig = require("mason-lspconfig")
    -- ── Diagnostics UI ──────────────────────────────
    local excluded = { "jdtls" }
    vim.lsp.config("jdtls", { enabled = false })
    vim.lsp.enable("jdtls", false)
    local installed_servers = mason_lspconfig.get_installed_servers()

    for _, server_name in ipairs(installed_servers) do
      -- Skip servers we already configured above with custom settings
      -- Skip java
      if not servers[server_name] and not vim.tbl_contains(excluded, server_name) then
        vim.lsp.config(server_name, {
          capabilities = capabilities,
        })
        vim.lsp.enable(server_name)
      end
    end
  end,
}
