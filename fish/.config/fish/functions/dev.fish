function dev --wraps='nvim -u "$HOME/.config/nvim/init.dev.lua"' --description 'alias dev=nvim -u "$HOME/.config/nvim/init.dev.lua"'
  nvim -u "$HOME/.config/nvim/init.dev.lua" $argv
        
end
