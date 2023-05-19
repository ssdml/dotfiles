local M = {}


function M.split(input)
    local lines = {}

    for s in input:gmatch("([^\n]*)\n?") do
        table.insert(lines, s)
    end

    return lines
end


function M.with_modifiable(bufnr, change_buf)

    local is_modifiable = vim.api.nvim_buf_get_option(bufnr, "modifiable")

    if not is_modifiable then
        vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
    end

    change_buf()

    if not is_modifiable then
        vim.api.nvim_buf_set_option(bufnr, "modifiable", is_modifiable)
    end
end

return M

