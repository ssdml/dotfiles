local utils = require('notesclient.utils')

local M = {}

M.counter = 0

function M.show_in_new_buf(input, modifirable)
    local lines = {}

    if type(input) == 'string' then
        lines = utils.split(input)

    elseif type(input) == 'table' then
        lines = input

    else
        return
    end

    local buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_win_set_buf(0, buf)

    vim.api.nvim_buf_set_option(buf, "buftype", "")
    vim.api.nvim_buf_set_option(buf, 'modifiable', modifirable)

    M.counter = M.counter + 1
    vim.api.nvim_buf_set_name(buf, 'temp/file_' .. M.counter .. '.takenote')

    vim.api.nvim_buf_set_option(buf, "modified", false)
end

return M
