return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local startify = require("alpha.themes.startify")
		startify.section.header.val = {
			[[  ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗ ]],
			[[  ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║ ]],
			[[  ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║ ]],
			[[  ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║ ]],
			[[  ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║ ]],
			[[  ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝ ]],
		}
		startify.section.top_buttons.val = {
			startify.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
            startify.button("r", "  Recently Opened Files", ":Telescope oldfiles<CR>")
        }
        startify.section.mru.autocd = true
		-- startify.nvim_web_devicons.highlight = false
		-- startify.nvim_web_devicons.highlight = 'Keyword'
		--
		startify.section.bottom_buttons.val = {
			startify.button("q", "󰅚  Quit NVIM", ":qa<CR>"),
		}
		alpha.setup(startify.config)

        vim.keymap.set("n", "<leader>hm", ":Alpha<CR>", {})
	end,
}
