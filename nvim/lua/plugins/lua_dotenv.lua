return {
    "mcjkula/lua-dotenv",
    lazy = false,
    priority = 1000,
    config = function()
        dofile(vim.fn.expand("~/.config/lua/env_setup.lua"))
    end,
}
