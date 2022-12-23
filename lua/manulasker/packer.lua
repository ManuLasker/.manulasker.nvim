-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
    -- core
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'

    -- telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- treesitter
    use("nvim-treesitter/nvim-treesitter", {
        run = ":TSUpdate"
    })
    use("nvim-treesitter/playground")
    use { -- Additional text objects via treesitter
        'nvim-treesitter/nvim-treesitter-textobjects',
        after = 'nvim-treesitter',
    }

    -- appearance
    use({
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    })

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
            {"tzachar/cmp-tabnine", { run = "./install.sh" }},
            {"onsails/lspkind-nvim"},
            {'j-hui/fidget.nvim'},

            -- Useful status updates for LSP
            'j-hui/fidget.nvim',

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }

    -- learn vim
    use("ThePrimeagen/vim-be-good")

end)
