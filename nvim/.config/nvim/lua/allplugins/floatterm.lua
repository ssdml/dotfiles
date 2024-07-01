return {
    'voldikss/vim-floaterm',
    event='VeryLazy',
    init = function()
        vim.keymap.set("n", "<A-f>", function() vim.cmd("FloatermToggle") end)
        vim.keymap.set("t", "<A-f>", function() vim.cmd("FloatermToggle") end)
    end
}
