-- Setting options
require('settings')

-- Basic Keymaps
require('basickeymaps')

function P(value)
    print(vim.inspect(value))
end

local init_lazy_pm = require('lazyconf')
init_lazy_pm('devplugins')

