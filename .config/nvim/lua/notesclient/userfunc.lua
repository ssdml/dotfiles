local api = require('notesclient.api')
local display = require('notesclient.display')
local utils = require('notesclient.utils')


local M = {}

function M._parse_entity_line(line)
    local match

    match = string.match(line, '^%s*@note%((%d+)%)')

    if match ~= nil then
        return 'note', match
    end

    match = string.match(line, '^%s*@todo%((%d+)%)')

    if match ~= nil then
        return 'todo', match
    end

    return nil, nil
end


function M.new_note()
    display.show_in_new_buf('@type: note', true)
end


function M.show_note(opts)
    local note_id = opts.args
    local text_note = api.get_note(note_id)

    if text_note == nil then
        display.show_in_new_buf('Error loading note with id = ' .. note_id, true)
        return
    end

    if text_note == nil then
        return
    end

    display.show_in_new_buf(text_note, true)
end


function M.list_notes(cmd_params)
    local query_params = {}

    if cmd_params['args'] ~= '' then
        query_params['substr'] = cmd_params['args']
    end

    local fetched = api.get_notes(query_params)

    if fetched == nil or fetched.text == nil then
        display.show_in_new_buf('Error listing notes', false)
        return
    end

    display.show_in_new_buf(utils.split(fetched.text), false)

end


function M.new_todo()
    display.show_in_new_buf('@type: todo', true)
end


function M.show_todo(opts)
    local todo_id = opts.args
    local todo_text = api.get_todo(todo_id)

    if todo_text == nil then
        display.show_in_new_buf('Error loading todo with id = ' .. todo_id, true)
        return
    end

    if todo_text == nil then
        return
    end

    display.show_in_new_buf(todo_text, true)
end


function M.list_todos(cmd_params)
    local query_params = {}

    if cmd_params['args'] ~= '' then
        query_params['substr'] = cmd_params['args']
    end

    local fetched = api.get_todos(query_params)

    -- TODO: put error handling in separated function
    if fetched == nil or fetched.text == nil then
        display.show_in_new_buf('Error listing todos', false)
        return
    end

    display.show_in_new_buf(utils.split(fetched.text), false)
end


function M.open_under_cursor()
    local entity_type, entity_id = M._parse_entity_line(vim.api.nvim_get_current_line())

    local func_table = {
        ['note'] = function () M.show_note({args = entity_id}) end,
        ['todo'] = function () M.show_todo({args = entity_id}) end,
    }

    local func = func_table[entity_type]

    if func == nil then
        return
    end

    func()
end


function M.save_text_entity(event_data)
    local buf_num =  event_data['buf']

    local buf_lines = vim.api.nvim_buf_get_lines(buf_num, 0, -1, false)
    local text = table.concat(buf_lines, '\n')

    local api_result = api.save_text_entity(text)

    if api_result == nil or api_result['text'] == nil then
        print('Error while savinig object')
    end

    local new_buf_lines = {}

    for line in api_result['text']:gmatch("([^\n]*)\n?") do
        table.insert(new_buf_lines, line)
    end

    vim.api.nvim_buf_set_lines(buf_num, 0, -1, false, new_buf_lines)

    vim.api.nvim_buf_set_option(buf_num, 'modified', false)
end


function M.unfold_entity()
    local current_row, _ = unpack(vim.api.nvim_win_get_cursor(0))

    local current_buf = vim.api.nvim_get_current_buf()

    local line = vim.api.nvim_get_current_line()

    local entity_type, _ = M._parse_entity_line(line)

    local new_text

    if entity_type then
        new_text = api.get_text_by_line(line)
    end

    if new_text ~= nil then
        vim.api.nvim_buf_set_lines(
            current_buf, current_row - 1, current_row, false, utils.split(new_text))
    end
end


function M.login()
    local username = vim.fn.input('Username: ')
    local password = vim.fn.inputsecret('Password: ')

    local result = api.login(username, password)

    if result == nil then
        return
    end

    if result['message'] ~= nil then
        print(result['message'])
    end
end


return M

