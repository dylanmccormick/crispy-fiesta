return {
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			local present = require("nvim-tree")
			present.setup({})
		end,
	},
}
