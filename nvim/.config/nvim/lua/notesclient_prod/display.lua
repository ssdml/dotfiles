local utils = require(NC_MODULE_NAME .. '.utils')


local function get_option(options, key, default)
    local result = options[key]

    if result == nil then
        return default
    end

    return result
end


local M = {}

M.counter = 0

function M.find_buf_by_match(match_function)
    for _, cur_buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(cur_buf) then

            local cur_buf_name = vim.api.nvim_buf_get_name(cur_buf)

            if match_function(cur_buf_name) then
                return cur_buf
            end
        end
    end

    return nil
end

function M.find_buf_by_name(name)
    if name == nil then
        return nil
    end

    local match_function = function (current_name)
        return current_name:sub(-#name) == name
    end

    local extracted_id = string.match(name, '|%s*id=(%d+)[^|]*$')
    if extracted_id then
        local pattern = '|%s*id=' .. extracted_id .. '[^|]*$'

        match_function = function (current_name)
            return string.match(current_name, pattern)
        end
    end

    return M.find_buf_by_match(match_function)
end



function M.init_buf_by_name(file_name)
    local buf
    if file_name == nil then

        M.counter = M.counter + 1
        buf = M.create_buffer('takenote item ' .. M.counter)

    else
        if buf == nil then
            buf = M.create_buffer(file_name)
        end
    end

    return buf
end

function M.create_buffer(name)
    local buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_name(buf, name)
    vim.api.nvim_buf_set_option(buf, "buftype", "")
    vim.api.nvim_buf_set_option(buf, "modified", false)
    vim.api.nvim_buf_set_option(buf, "filetype", NC_FILETYPE)

    return buf
end

function M.parse_lines(input)
    local lines

    if type(input) == 'string' then
        lines = utils.split(input)

    elseif type(input) == 'table' then
        lines = input
    end

    return lines

end

function M.show_in_new_buf(input, options)
    local buf = get_option(options, 'buf', nil)

    if buf == nil then
        buf = M.init_buf_by_name(get_option(options, 'file_name', nil))
    end

    if buf == nil then
        return
    end

    local lines = M.parse_lines(input)
    if lines == nil then
        return
    end

    if not vim.api.nvim_buf_get_option(buf, 'modified') then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.api.nvim_buf_set_option(buf, "modified", false)
    end

    vim.api.nvim_buf_set_option(buf, 'modifiable', get_option(options, 'modifiable', true))
    vim.api.nvim_win_set_buf(0, buf)

end

return M
