local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
    return
end

lazy.setup({
    {
        -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        init_options = {
            userLanguages = {
                eelixir = "html-eex",
                eruby = "erb",
                rust = "html",
            },
        },
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { "williamboman/mason.nvim", config = true },
            "williamboman/mason-lspconfig.nvim",

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { "j-hui/fidget.nvim", tag = "legacy", opts = {} },

            -- Additional lua configuration, makes nvim stuff amazing!
            "folke/neodev.nvim",
        },
    },

    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate", -- :MasonUpdate updates registry contents
        cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
        config = function()
            require("plugins.configs.mason")
        end,
    },
    {
        -- Autocompletion
        "hrsh7th/nvim-cmp",
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-path",

            "hrsh7th/cmp-buffer",
            -- Adds LSP completion capabilities
            "hrsh7th/cmp-nvim-lsp",

            -- Adds a number of user-friendly snippets
            "rafamadriz/friendly-snippets",
        },
        config = function()
            require("plugins.configs.cmp")
        end,
    },
    { "onsails/lspkind.nvim" },

    {	"catppuccin/nvim", 
	config = function()
	  require("plugins.configs.catppuccin")
	end,
    },
    -- {
    --   "user/repo",
    --   dependencies = {
    --     "user/repo2"
    --   },
    --   config = function()
    --     require("plugins.configs.repo")
    --   end
    -- }
})

