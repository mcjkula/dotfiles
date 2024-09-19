return {
    "mcjkula/gen42.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",  -- Keep this for HTTP requests
    },
    config = function()
        require("gen42").setup({
            api_key = "sk-m86z2FcWwSTvuGwdzhibCQ",
            api_base = "http://api.gen42.ai/v1",
            model = "code",
        })
    end,
    event = "VeryLazy",
}
