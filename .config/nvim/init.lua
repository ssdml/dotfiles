-- Setting options
require('settings')

-- Basic Keymaps
require('basickeymaps')

function P(value)
    print(vim.inspect(value))
end

require('lazyconf')

require('notesclient_prod').setup({
    MODULE_NAME = 'notesclient_prod',
    SERVER_HOST = 'https://94.198.218.24:443',
})
