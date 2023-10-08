local io = require('io')

local http = require('socket.http')
local ltn12 = require('ltn12')
local json = require(NC_MODULE_NAME .. '.json')

local host = NC_SERVER_HOST
local note_api_url = host .. '/api/v1/textmode/note/list/'
local todo_api_url = host .. '/api/v1/textmode/todo/list/'

local note_api_url_txt = host .. '/api/v1/textmode/note/'
local todo_api_url_txt = host .. '/api/v1/textmode/todo/'
local today_api_url_txt = host .. '/api/v1/textmode/today/'

local today_bydate_api_url_txt = host .. '/api/v1/textmode/today/bydate/'

local item_by_line_url_txt = host .. '/api/v1/textmode/byline/'

local save_text_url = host .. '/api/v1/textmode/parse/'

local login_api_url = host .. '/api/v1/login/'

local session_file_path = debug.getinfo(1).source:match("@?(.*/)") .. 'z_session.txt'


local function read_from_session_file()
    local session_file = io.open(session_file_path, 'r')

    if session_file ~= nil then
        local cookie_session = session_file:read()
        session_file:close()
        return cookie_session
    end

    return nil
end


local function write_to_session_file(cookie_session)
        if cookie_session == nil then
            return
        end

        local session_file = io.open(session_file_path, 'w')
        if session_file then
            session_file:write(cookie_session)
            session_file:close()
        end
end


local api = {}

api.cookie_session = read_from_session_file()

local function make_json_request(url, method, params)
    local params_string = json.stringify(params)

    local request_headers = {
        ["content-type"] = 'application/json',
        ["content-length"] = tostring(#params_string)
    }

    if api.cookie_session ~= nil then
        request_headers['cookie'] = api.cookie_session
    end

    local respbody = {}

    -- res, code, headers, status
    local _, code, response_headers, _ = http.request{
        url = url,
        method = method,
        sink = ltn12.sink.table(respbody),
        source = ltn12.source.string(params_string),
        headers = request_headers,
    }

    local cookie_session

    if response_headers['set-cookie'] ~= nil then
        cookie_session = string.match(response_headers['set-cookie'], 'session=[^;]+;')
    end

    if respbody[1] == nil then
        return code, cookie_session, nil
    end

    if code == 200 then
        return code, cookie_session, json.parse(table.concat(respbody))
    end

    return code, cookie_session, nil

end


local function fetch_json_data(url, method, params)
    local code, _, json_data = make_json_request(url, method, params)

    if json_data == nil then
        json_data = {}
    end

    return code, json_data
end

function api.get_text_by_line(item_line)
    if item_line == nil then
        return nil
    end

    local params = {line = item_line}

    local code, result = fetch_json_data(item_by_line_url_txt, 'GET', params)

    if code ~= 200 then
        return nil
    end

    return result.text
end


function _get_result_by_url(url, params)
    local code, result = fetch_json_data(url, 'GET', params)

    if code ~= 200 then
        return nil
    end

    return result
end


function api.get_today_by_date(date)
    return _get_result_by_url(today_bydate_api_url_txt .. date .. '/', {})
end


function api.get_today(today_id)
    if today_id == nil then
        return nil
    end

    return _get_result_by_url(today_api_url_txt .. today_id .. '/',  {})
end


function api.get_note(note_id)
    if note_id == nil then
        return nil
    end

    return _get_result_by_url(note_api_url_txt .. note_id .. '/',  {})
end


function api.get_todo(todo_id)
    if todo_id == nil then
        return nil
    end

    return _get_result_by_url(todo_api_url_txt .. todo_id .. '/', {})
end


function api.get_notes(params)
    if params == nil then
        params = {}
    end

    local code, result = fetch_json_data(note_api_url, 'GET', params)

    if code ~= 200 then
        return nil
    end

    return result
end


function api.get_todos(params)
    if params == nil then
        params = {}
    end

    local code, result = fetch_json_data(todo_api_url, 'GET', params)

    if code ~= 200 then
        return nil
    end

    return result
end


function api.save_text_entity(text)
    local code, result = fetch_json_data(save_text_url, 'POST', {text=text})

    if code ~= 200 then
        return nil
    end

    return result
end


function api.login(login, password)
    local code, cookie_session, result = make_json_request(login_api_url, 'POST', {login=login, password=password})

    if cookie_session then
        api.cookie_session = cookie_session

        write_to_session_file(cookie_session)
    end

    if code ~= 200 then
        return nil
    end

    return result
end


return api

