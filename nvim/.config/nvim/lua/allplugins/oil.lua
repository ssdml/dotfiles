return {
    'stevearc/oil.nvim',

    dependencies = { "nvim-tree/nvim-web-devicons" },

    use_default_map = false,

    config = function()

        local gheight = vim.api.nvim_list_uis()[1].height
        local gwidth = vim.api.nvim_list_uis()[1].width

        local float_width = math.floor(gwidth * 0.5)
        local float_height = math.floor(gheight * 0.8)

        require('oil').setup({
            columns = {"icon", "permissions"},

            use_default_keymaps = false,
            keymaps = {
                ["g?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["<C-s>"] = "actions.select_vsplit",
                -- ["<C-h>"] = "actions.select_split",
                -- ["<C-t>"] = "actions.select_tab",
                -- ["<C-m>"] = "actions.preview",
                ["<C-c>"] = "actions.close",
                ["<C-l>"] = "actions.refresh",
                ["-"] = "actions.parent",
                -- ["_"] = "actions.open_cwd",
                -- ["`"] = "actions.cd",
                -- ["~"] = "actions.tcd",
                ["gs"] = "actions.change_sort",
                -- ["gx"] = "actions.open_external",
                ["g."] = "actions.toggle_hidden",
                ["g\\"] = "actions.toggle_trash",
            },

            float = {
                -- Padding around the floating window
                padding = 10,

                max_width = float_width,
                max_height = float_height ,
                -- border = "rounded",
                -- win_options = {
                --     winblend = 0,
                -- },
                -- override = function(conf)
                --     return conf
                -- end,
            },
        })


        vim.keymap.set('n', '<leader>e', ':Oil --float<CR>')
        vim.keymap.set('n', '<leader>E', ':Oil --float .<CR>')
    end
}
