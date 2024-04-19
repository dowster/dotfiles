vim.cmd("set number")
vim.cmd("set relativenumber")

vim.cmd("set tabstop=4 softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set expandtab")
vim.cmd("set smartindent")

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

vim.g.mapleader = ","

require("lazy").setup({
--  {
--    "folke/tokyonight.nvim",
--    lazy = false, -- make sure we load this during startup if it is your main colorscheme
--    priority = 1000, -- make sure to load this before all the other start plugins
--    config = function()
--      -- load the colorscheme here
--      vim.cmd([[colorscheme tokyonight]])
--    end,
--  },
  "folke/which-key.nvim",
  { "folke/neoconf.nvim", cmd = "Neoconf" },
  "folke/neodev.nvim",
  { 
      "neovim/nvim-lspconfig",
      dependencies = {
          "williamboman/mason.nvim",
          "williamboman/mason-lspconfig.nvim",
     },

     config = function()
         local lspconfig = require("lspconfig")

         require("mason").setup()
         require("mason-lspconfig").setup {
            ensure_installed = {
                -- "bash-debug-adapter",
                "bashls",
                -- "go-debug-adapter",
                "gopls",
                "lua_ls",
                "rust_analyzer",
                -- "shfmt",
                -- "stylua",
                "terraformls",
                "tflint",
                "yamlls"
            }
         }

         require("mason-lspconfig").setup_handlers({
             function(server)
                 lspconfig[server].setup({})
             end,
         })
     end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
    config = function()
        local cmp = require'cmp'

        cmp.setup({
            snippet = {
              -- REQUIRED - you must specify a snippet engine
              expand = function(args)
                vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
              end,
            },
            window = {
              -- completion = cmp.config.window.bordered(),
              -- documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'vsnip' }, -- For vsnip users.
              -- { name = 'luasnip' }, -- For luasnip users.
              -- { name = 'ultisnips' }, -- For ultisnips users.
              -- { name = 'snippy' }, -- For snippy users.
            }, {
              { name = 'buffer' },
            })
          })
    end,
  },
}, {})

