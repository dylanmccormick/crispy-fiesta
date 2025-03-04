return {
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("obsidian").setup({
				workspaces = {
					{
						name = "main",
						path = "/home/wildkarrde/notes",
					},
				},
				notes_subdir = "inbox",
				new_notes_location = "notes_subdir",
				disable_frontmatter = true,
				templates = {
					subdir = "templates",
					date_format = "%Y-%m-%d",
					time_format = "%H:%M:%S",
				},

				mappings = {
					["gf"] = {
						action = function()
							return require("obsidian").util.gf_passthrough()
						end,
						opts = { noremap = false, expr = true, buffer = true },
					},
					["<leader>ti"] = {
						action = function()
							return require("obsidian").util.toggle_checkbox()
						end,
						opts = { buffer = true },
					},
				},

				completion = {
					blink = true,
					min_chars = 2,
				},

				ui = {
					checkboxes = {},
					bullets = {},
				},
			})
		end,
	},
}
