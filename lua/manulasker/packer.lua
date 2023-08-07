-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
    -- core
    use 'wbthomason/packer.nvim'

    -- telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- appearance
    use({
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    })

    use({
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup {
                icons = false,
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    })

    -- treesitter
    use("nvim-treesitter/nvim-treesitter", {
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end
    })
    use("nvim-treesitter/playground")
    -- use("theprimeagen/refactoring.nvim")
    use("nvim-treesitter/nvim-treesitter-context");

    -- fancy status line
    use 'nvim-lualine/lualine.nvim'

    -- indentation
    use 'lukas-reineke/indent-blankline.nvim'

    -- navigation
    use('theprimeagen/harpoon')

    -- control changes
    use('mbbill/undotree')
    use('tpope/vim-fugitive')

    -- lsp
    use { -- Lsp 0 plugin management
            'VonHeikemen/lsp-zero.nvim',
            requires = {
                -- LSP Support
                {'neovim/nvim-lspconfig'},
                {'williamboman/mason.nvim'},
                {'williamboman/mason-lspconfig.nvim'},

                -- Autocompletion
                {'hrsh7th/nvim-cmp'},
                {'hrsh7th/cmp-buffer'},
                {'hrsh7th/cmp-path'},
                {'saadparwaiz1/cmp_luasnip'},
                {'hrsh7th/cmp-nvim-lsp'},
                {'hrsh7th/cmp-nvim-lua'},

                -- Snippets
                {'L3MON4D3/LuaSnip'},
                {'rafamadriz/friendly-snippets'},
            }
    }

    -- markdown
    use { "iamcco/markdown-preview.nvim", build = "cd app && yarn install" }

    -- learn vim
    use("ThePrimeagen/vim-be-good")
    -- copilot
    use("github/copilot.vim")
end)
