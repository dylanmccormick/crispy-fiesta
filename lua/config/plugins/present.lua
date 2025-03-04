--lua/custom/plugins/present.lua
return {
	{
		"tjdevries/present.nvim",
		config = function()
			local present = require("present")
			present.setup({})
		end,
	},
}
