vim.keymap.set("n", "<leader>oo", ":cd /home/wildkarrde/notes<cr>")

vim.keymap.set("n", "<leader>on", ":ObsidianTemplate note<cr> :lua vim.cmd([[1,/^\\n\\{1,}//]]<cr>")

vim.keymap.set("n", "<leader>of", ":s/\\(# \\)[^_]*_/\\1/ | s/-/ /g | :set nohls <cr>")
