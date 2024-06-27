local api = require(NC_MODULE_NAME .. '.api')
local display = require(NC_MODULE_NAME .. '.display')
local utils = require(NC_MODULE_NAME .. '.utils')


local function message(mess)
    print(mess)
end


local M = {}


local function _show_fetched(fetched, error_msg)

    if fetched == nil or fetched.text == nil then
        display.show_in_new_buf(error_msg, {})
        return
    end

    display.show_in_new_buf(fetched.text, {modifiable = false})
end


function M._parse_entity_line(line)
    local entity_type, entity_id = string.match(line, '^%s*@(%a+):.*|%s*id=(%d+)$')

    if entity_type ~= nil then

        if entity_type == 'note' then
            return 'note', entity_id
        end

        if entity_type == 'task' or entity_type == 'done' or entity_type == 'todo' then
            return 'todo', entity_id
        end
    end

    entity_id = string.match(line, '|%s*id=(%d+)%s*$')

    if entity_id ~= nil then
        entity_type = string.match(line, '^%s*@parent:%s*[(](%a+)[)]')

        if entity_type == 'task' or entity_type == 'done' or entity_type == 'todo' then
            entity_type = 'todo'
        end

        return entity_type, entity_id
    end

    return nil, nil
end


function M._show_item(item_id, input_buf_name, fetch_func)

    local item_json = fetch_func(item_id)

    local fetched_buf_name = item_json['name']

    local buf_name
    if input_buf_name then
        buf_name = input_buf_name

    elseif fetched_buf_name then
        buf_name = fetched_buf_name

    else
        message("Couldn't get buf_name")
        return
    end

    -- TODO: make better buffer find finction. Use another aproach to compare names
    local buf = display.find_buf_by_name(buf_name)

    if M._check_buf_modifired(buf) then
        return
    end

    if item_json == nil then
        message('Error loading item with id = ' .. item_id .. ' to buf "' .. buf_name .. '"')
        return
    end

    if item_json['deleted'] ~= nil then
        message('Item with id = ' .. item_id .. ' has been deleted')
        return
    end

    local text_note = item_json['text']

    if text_note == nil then
        return
    end

    display.show_in_new_buf(text_note, {modifiable = true, file_name = buf_name, buf = buf})

end


function M.new_note()
    display.show_in_new_buf('@type: note', {})
end

function M._check_buf_modifired(buf)
    if buf ~= nil then
        if vim.api.nvim_buf_get_option(buf, 'modified') then
            local buf_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':t')

            message('Buffer: "' .. buf_name .. '" is modifired. Please save buffer data')
            return true
        end
    end

    return false
end


function M.show_today_by_date(cmd_params)
    local today

    if cmd_params['args'] ~= '' then
        today = cmd_params['args']
    else
        today = os.date('%d.%m.%Y')
    end

    M._show_item(today, nil, api.get_today_by_date)
end

function M.show_today(opts)
    local today_id = opts.args
    M._show_item(today_id, nil, api.get_today)
end


function M.show_note(opts)
    local note_id = opts.args

    M._show_item(note_id, nil, api.get_note)
end


function M.show_todo(opts)
    local todo_id = opts.args

    M._show_item(todo_id, nil, api.get_todo)
end


function M.search_notes(cmd_params)
    local query_params = {}

    if cmd_params['args'] ~= '' then
        query_params['substr'] = cmd_params['args']
    end

    local fetched = api.get_notes(query_params)

    _show_fetched(fetched, 'Error listing notes')
end


function M.list_notes()
    local fetched = api.get_notes({only_root = true})

    _show_fetched(fetched, 'Error listing notes')
end


function M.new_todo()
    display.show_in_new_buf('@type: todo', {})
end


function M.list_todos()
    local fetched = api.get_todos({})
    _show_fetched(fetched, 'Error listing todos')
end


function M.search_todos(cmd_params)
    local query_params = {}

    if cmd_params['args'] ~= '' then
        query_params['substr'] = cmd_params['args']
    end

    local fetched = api.get_todos(query_params)
    _show_fetched(fetched, 'Error listing todos')
end


function M.open_under_cursor()
    if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), 'filetype') ~= NC_FILETYPE then
        return true
    end

    local entity_type, entity_id = M._parse_entity_line(vim.api.nvim_get_current_line())

    local func_table = {
        ['note'] = function () M.show_note({args = entity_id}) end,
        ['todo'] = function () M.show_todo({args = entity_id}) end,
        ['today'] = function () M.show_today({args = entity_id}) end,
    }

    local func = func_table[entity_type]

    if func == nil then
        return
    end

    func()
end


function M.save_text_entity(event_data)
    local buf_num =  event_data['buf']

    if vim.api.nvim_buf_get_option(buf_num, 'filetype') ~= NC_FILETYPE then
        return true
    end

    if not vim.api.nvim_buf_get_option(buf_num, 'modifiable') then
        return
    end

    local buf_lines = vim.api.nvim_buf_get_lines(buf_num, 0, -1, false)
    local text = table.concat(buf_lines, '\n')

    local api_result = api.save_text_entity(text)

    if api_result == nil or api_result['text'] == nil then
        message('Error while savinig object')
        return
    end

    if api_result['action'] == 'deleted' then
        message('Element has been deleted')
        vim.api.nvim_buf_delete(buf_num, {force = true})
        return
    end

    local new_buf_lines = {}

    for line in api_result['text']:gmatch("([^\n]*)\n?") do
        table.insert(new_buf_lines, line)
    end


    vim.api.nvim_buf_set_lines(buf_num, 0, -1, false, new_buf_lines)

    local buf_name = api_result['name']

    if buf_name == nil then
        -- TODO: get rid of this code if api_result['name'] works well
        buf_name = api_result['type'] .. '_'
        if api_result['type'] == 'today' then
            buf_name = buf_name .. tostring(api_result['date'])
        else
            buf_name = buf_name .. tostring(api_result['id'])
        end

    end


    vim.api.nvim_buf_set_name(buf_num, buf_name)

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

    local old_modifired = vim.api.nvim_buf_get_option(current_buf, 'modified')

    if new_text ~= nil then
        vim.api.nvim_buf_set_lines(
            current_buf, current_row - 1, current_row, false, utils.split(new_text))

        vim.api.nvim_buf_set_option(current_buf, 'modified', old_modifired)
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

