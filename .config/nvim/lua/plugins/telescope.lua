return {
    "nvim-telescope/telescope.nvim",
    tag = '0.1.5',
    dependencies = {'nvim-lua/plenary.nvim'},
    config = function ()
        local actions = require('telescope.actions')

        require('telescope').setup {
          defaults = {
            mappings = {
              i = {
            ['<C-n>'] = false,
            ['<C-p>'] = false,

            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,

              },
            },
          },
        }

        -- See `:help telescope.builtin`
        vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
        vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })

        vim.keymap.set('n', '<leader>/', require('telescope.builtin').current_buffer_fuzzy_find, { desc = '[/] Fuzzily search in current buffer]' })

        vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<c-p>', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })

        vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })

        vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[G]rep' })
        vim.keymap.set('n', '<C-g>', require('telescope.builtin').live_grep, { desc = '[G]rep' })

        vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
    end
}

