return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")

			vim.api.nvim_set_keymap(
				"n",
				"<leader>fp",
				":lua require'telescope'.extensions.project.project{}<CR>",
				{ noremap = true, silent = true }
			)

			vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			vim.keymap.set("n", "<leader>ps", function()
				builtin.grep_string({ search = vim.fn.input("Grep > ") })
			end)
			vim.keymap.set("n", "<leader>rf", builtin.oldfiles, {})
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
    --[[{
		"nvim-telescope/telescope-file-browser.nvim",
		config = function()
			-- You don't need to set any of these options.
			-- IMPORTANT!: this is only a showcase of how you can set default options!
			require("telescope").setup({
				extensions = {
					file_browser = {
						hijack_netrw = true,
                        browse_folders = require("telescope._extensions.file_browser.finders").browse_folders,
                        auto_depth = true,
                        display_stat = { size = true, mode = true },
                        cwd_to_path = true,
					},
				},
			})
            vim.keymap.set("n", "<leader>fb", ":Telescope file_browser<CR>", {})

			require("telescope").load_extension("file_browser")
		end,
	},--]]
}
