return {
    "mcjkula/gen42.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "mcjkula/lua-dotenv",
    },
    config = function()
        require("gen42").setup({
            api_key = dotenv.get("API_KEY"),
            api_base = "http://api.gen42.ai/v1",
            model = "code",
        })
    end,
    event = "VeryLazy",
}
