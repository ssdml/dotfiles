local M = {}

NC_FILETYPE = 'notetake'

function M.setup(options)

    NC_MODULE_NAME = 'notesclient'
    NC_SERVER_HOST = 'http://127.0.0.1:5000'
    NC_CONFIG_PATH = vim.fn.stdpath("cache") .. "/znotesclientconfig.json"

    if options then
        if options.MODULE_NAME ~= nil then
            NC_MODULE_NAME = options.MODULE_NAME
        end

        if options.SERVER_HOST ~= nil then
            NC_SERVER_HOST = options.SERVER_HOST
        end

        if options.CONFIG_PATH then
            NC_CONFIG_PATH = options.CONFIG_PATH
        end
    end


    local usrf = require(NC_MODULE_NAME .. '.userfunc')

    local cmd_prx = 'Z'  -- [Z]apisi


    vim.api.nvim_create_autocmd(
        {'BufWriteCmd'},
        {callback = usrf.save_text_entity}
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

    vim.cmd('autocmd FileType ' .. NC_FILETYPE .. ' :noremap <buffer> <Enter> ' .. ':' .. cmd_prx .. 'OpenUnderCursor<CR>')


    vim.api.nvim_create_user_command(cmd_prx .. 'Unfold', usrf.unfold_entity, {})

end


return M
