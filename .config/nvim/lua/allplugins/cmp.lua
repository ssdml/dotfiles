return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        'hrsh7th/cmp-buffer', -- source for text in buffer
        'hrsh7th/cmp-path',   -- source for file system paths
        'neovim/nvim-lspconfig',
        'hrsh7th/cmp-nvim-lsp',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'Exafunction/codeium.nvim',

        {
            'L3MON4D3/LuaSnip',
            -- follow latest release.
            version = 'v2.*', -- Replace <CurrentMajor> by the latest released major (first number of latest release)
            -- install jsregexp (optional!).
            build = 'make install_jsregexp',
        },
        -- 'saadparwaiz1/cmp_luasnip', -- for autocompletion
        -- 'rafamadriz/friendly-snippets', -- useful snippets
        -- 'onsails/lspkind.nvim', -- vs-code like pictograms
    },
    config = function()
        local cmp = require('cmp')

        local luasnip = require('luasnip')

        -- local lspkind = require('lspkind')

        -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
        -- require('luasnip.loaders.from_vscode').lazy_load()

        cmp.setup({
            completion = {
                completeopt = 'menu,menuone,preview,noselect',
            },
            snippet = {
                        -- configure how nvim-cmp interacts with snippet engine
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-j>'] = cmp.mapping.select_next_item(),   -- next suggestion
                ['<C-k>'] = cmp.mapping.select_prev_item(),   -- previous suggestion

                ['<Tab>'] = cmp.mapping.select_next_item(),   -- next suggestion
                ['<S-Tab>'] = cmp.mapping.select_prev_item(), -- previous suggestion

                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),

                ['<C-Space>'] = cmp.mapping.complete(), -- show completion suggestions

                ['<C-e>'] = cmp.mapping.abort(),        -- close completion window

                ['<CR>'] = cmp.mapping.confirm({ select = true }),
            }),
            -- sources for autocompletion
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'path' },    -- file system paths
                { name = 'buffer' },  -- text within current buffer
                { name = 'luasnip' }, -- snippets
                { name = 'codeium' }  -- Codeium AI
            }),

            -- configure lspkind for vs-code like pictograms in completion menu
            -- formatting = {
            --   format = lspkind.cmp_format({
            --     maxwidth = 50,
            --     ellipsis_char = '...',
            --   }),
            -- },
        })



        require('mason').setup()

        local mason_lspconfig = require('mason-lspconfig')

        mason_lspconfig.setup({
            ensure_installed = { 'pyright', 'ruff', 'lua_ls' }
        })

        -- Set up lspconfig.
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

        mason_lspconfig.setup_handlers {
            function(server_name)
                require('lspconfig')[server_name].setup({
                    capabilities = capabilities,
                    on_attach = function(_, bufnr)
                        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                            vim.lsp.buf.format()
                        end, { desc = 'Format current buffer with LSP' })
                    end
                })
            end,

        }
    end,
}


-- return {
--
--     'hrsh7th/cmp-nvim-lsp',
--
--     dependencies = {
--         'williamboman/mason.nvim',
--         'williamboman/mason-lspconfig.nvim',
--         'neovim/nvim-lspconfig',
--         'hrsh7th/nvim-cmp',
--         'L3MON4D3/LuaSnip'
--     },
--
--     event = 'InsertEnter',
--
--     config = function()
--         local cmp = require('cmp')
--         local luasnip = require('luasnip')
--
--         cmp.setup({
--
--             snippet = {
--                 expand = function(args)
--                     luasnip.lsp_expand(args.body)
--                 end
--             },
--
--             sources = {
--                 { name = 'nvim_lsp' },
--                 { name = 'luasnip' },
--                 { name = 'path' },
--             },
--
--             mapping = cmp.mapping.preset.insert {
--                 ['<C-j>'] = cmp.mapping(
--                     function(fallback)
--                         if cmp.visible() then cmp.select_next_item() else fallback() end
--                     end
--                 ),
--                 ['<C-k>'] = (
--                     function(fallback)
--                         if cmp.visible() then cmp.select_prev_item() else fallback() end
--                     end
--                 ),
--
--                 ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--                 ['<C-f>'] = cmp.mapping.scroll_docs(4),
--                 ['<C-Space>'] = cmp.mapping.complete(),
--                 ['<CR>'] = cmp.mapping.confirm {
--                     behavior = cmp.ConfirmBehavior.Replace,
--                     select = true,
--                 },
--                 ['<Tab>'] = cmp.mapping(function(fallback)
--                     if cmp.visible() then
--                         cmp.select_next_item()
--                     elseif luasnip.expand_or_jumpable() then
--                         luasnip.expand_or_jump()
--                     else
--                         fallback()
--                     end
--                 end, { 'i', 's' }),
--                 ['<S-Tab>'] = cmp.mapping(function(fallback)
--                     if cmp.visible() then
--                         cmp.select_prev_item()
--                     elseif luasnip.jumpable(-1) then
--                         luasnip.jump(-1)
--                     else
--                         fallback()
--                     end
--                 end, { 'i', 's' }),
--             }
--         })
--
--         require('mason').setup()
--
--         local mason_lspconfig = require('mason-lspconfig')
--
--         mason_lspconfig.setup({
--             ensure_installed = { 'pyright', 'lua_ls' }
--         })
--
--         -- Set up lspconfig.
--         local capabilities = vim.lsp.protocol.make_client_capabilities()
--         capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
--
--         mason_lspconfig.setup_handlers {
--             function(server_name)
--                 require('lspconfig')[server_name].setup({
--                     capabilities = capabilities,
--                     on_attach = function(_, bufnr)
--                         vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
--                             vim.lsp.buf.format()
--                         end, { desc = 'Format current buffer with LSP' })
--                     end
--                 })
--             end,
--
--         }
--     end
-- }
