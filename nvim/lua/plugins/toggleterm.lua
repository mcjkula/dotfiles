return {
    --[=[
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup{
            start_in_insert = false,
            direction = "float",
            open_mapping = [[<leader>ft]],
            autochdir = true,
            close_on_exit = true,
            persist_size = false,
            shade_terminals = false,
        }
        vim.cmd([[
            autocmd TermEnter term://*toggleterm#* tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
        ]])
    end,
    ]=]
}

