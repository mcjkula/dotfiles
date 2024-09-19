local lazypath = vim.fn.stdpath("data") .."/lazy/lazy.nvim"
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
vim.opt.rtp:append(vim.fn.expand("~/.luarocks/share/lua/5.1"))

require("vim-opts")
require("lazy").setup("plugins")
