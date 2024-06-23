local function init_lazy_pm(plug_fold_name)

    if plug_fold_name == nil then
        plug_fold_name = 'plugins'
    end

    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)

    require("lazy").setup({ import = plug_fold_name })
end


return init_lazy_pm
