return {
    'stevearc/aerial.nvim',
    -- init = function ()
    --     vim.keymap.set('n', '<F1>', '<cmd>AerialToggle!<CR>', { noremap = true })
    --     vim.keymap.set('n', '<leader>t', '<cmd>AerialOpen<CR>', { noremap = true })
    -- end,

    keys = {
        {'<leader>t', '<cmd>AerialOpen<CR>'},
        { '<F1>', '<cmd>AerialToggle!<CR>' },
    },

    config = function ()
        require("aerial").setup()
    end
}
