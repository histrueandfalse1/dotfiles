-- Global LSP shortcuts
vim.keymap.set('n', '<leader>r', ':lua vim.lsp.stop_client(vim.lsp.get_clients())<CR>', { silent = true, desc = 'LSP Restart' })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP Go to Definition' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP Hover Documentation' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP Code Actions' })

-- Doc Generator keymap
vim.keymap.set("n", "<leader>df", ":lua require('neogen').generate()<CR>", { silent = true, desc = "Generate Doxygen Doc" })
