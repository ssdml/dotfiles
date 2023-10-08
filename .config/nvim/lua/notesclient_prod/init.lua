local M = {}

function M.setup(options)
    if options then
        NC_MODULE_NAME = options.MODULE_NAME
        NC_SERVER_HOST = options.SERVER_HOST
    else
        NC_MODULE_NAME = 'notesclient'
        NC_SERVER_HOST = 'https://94.198.218.24:80'
    end


    local usrf = require(NC_MODULE_NAME .. '.userfunc')

    local cmd_prx = 'Z'  -- [Z]apisi


    local file_pattern = '*.takenote'

    vim.api.nvim_create_autocmd(
        {'BufWriteCmd'},
        {pattern = file_pattern, callback = usrf.save_text_entity}
    )


    vim.api.nvim_create_user_command(cmd_prx .. 'Today', usrf.show_today_by_date, {nargs = '*'})


    vim.api.nvim_create_user_command(cmd_prx .. 'NewNote', usrf.new_note, {})
    vim.api.nvim_create_user_command(cmd_prx .. 'SearchNotes', usrf.search_notes, { nargs = '*' })
    vim.api.nvim_create_user_command(cmd_prx .. 'ListNotes', usrf.list_notes, {})
    vim.api.nvim_create_user_command(cmd_prx .. 'ShowNote', usrf.show_note, {nargs = 1})


    vim.api.nvim_create_user_command(cmd_prx .. 'NewTodo', usrf.new_todo, {})
    vim.api.nvim_create_user_command(cmd_prx .. 'SearchTodos', usrf.search_todos, { nargs = '*' })
    vim.api.nvim_create_user_command(cmd_prx .. 'ListTodos', usrf.list_todos, {})
    vim.api.nvim_create_user_command(cmd_prx .. 'ShowTodo', usrf.show_todo, {nargs = 1})

    vim.api.nvim_create_user_command(cmd_prx .. 'Login', usrf.login, {})

    vim.api.nvim_create_user_command(cmd_prx .. 'OpenUnderCursor', usrf.open_under_cursor, {})
    -- vim.api.nvim_set_keymap('n', '<Enter>', ':' .. cmd_prx .. 'OpenUnderCursor<CR>', {noremap = false})


    vim.api.nvim_create_user_command(cmd_prx .. 'Unfold', usrf.unfold_entity, {})

end


return M
