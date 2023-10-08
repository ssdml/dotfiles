-- [[ Nvim-tree config ]]
-- disable netrw at the very start of your init.lua (strongly advised) for nvim-tree plugin
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup({
  view = {
    float = {
      enable = true
    }
  }
})

vim.keymap.set('n', '<leader>e', ':NvimTreeFindFileToggle<CR>')

