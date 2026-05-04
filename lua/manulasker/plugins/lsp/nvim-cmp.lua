return {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        "zbirenbaum/copilot-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
    },

    config = function()
        require("copilot_cmp").setup() -- activate copilot suggestions

        local cmp = require("cmp")

        cmp.setup({
            -- ── Appearance ───────────────────────────────
            window = {
                completion    = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },

            -- ── Keymaps ──────────────────────────────────
            mapping = cmp.mapping.preset.insert({
                ["<C-k>"]     = cmp.mapping.select_prev_item(),
                ["<C-j>"]     = cmp.mapping.select_next_item(),
                ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
                ["<C-f>"]     = cmp.mapping.scroll_docs(4),
                ["<CR>"]      = cmp.mapping.confirm({ select = false }),
                ["<C-y>"]     = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"]     = cmp.mapping.abort(),
                ["<Tab>"]     = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"]   = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),

            -- ── Sources ──────────────────────────────────
            sources = cmp.config.sources({
                { name = "copilot",  priority = 1100 },
                { name = "nvim_lsp", priority = 1000 },
                { name = "buffer",   priority = 500 },
                { name = "path",     priority = 250 },
            }),


            -- ── Formatting ───────────────────────────────
            formatting = {
                format = function(entry, item)
                    item.menu = ({
                        copilot  = "[COPILOT]",
                        nvim_lsp = "[LSP]",
                        buffer   = "[Buf]",
                        path     = "[Path]",
                    })[entry.source.name]
                    return item
                end,
            },
        })
    end,
}
