local set = vim.keymap.set

set("n", "<CR>", function()
	---@diagnostic disable-next-line: undefined-field
	if vim.opt.hlsearch:get() then
		vim.cmd.nohlsearch()
		return ""
	else
		return "<CR>"
	end
end, { expr = true })

set("n", "<M-j>", "<cmd>cnext<CR>")
set("n", "<M-k>", "<cmd>cprev<CR>")
set("n", "-", "<cmd>Oil<CR>")

set("n", "<space><space>x", "<cmd>source %<CR>")
set("n", "<space>x", ":.lua<CR>")
set("v", "<space>x", ":lua<CR>")

set("n", "<M-j>", "<cmd>cnext<CR>")
set("n", "<M-k>", "<cmd>cprev<CR>")

set("n", "<leader>ft", "<cmd>NvimTreeFindFileToggle<cr>")
