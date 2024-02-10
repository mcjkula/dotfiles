return {
	"YannickFricke/codestats.nvim",
	config = function()
		require("codestats-nvim").setup({
			token = "SFMyNTY.YldOcWEzVnNZUT09IyNNakU1TVRVPQ.VWcJ60ZPw0oHvwb8cRy8tKQ--nU0DUPIC5yCUer4XQ8",
		})
	end,
	requires = { { "nvim-lua/plenary.nvim" } },
}
