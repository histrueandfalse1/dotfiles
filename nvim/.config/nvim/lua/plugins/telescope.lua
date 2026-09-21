return {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('telescope').setup({
            pickers = {
                find_files = {
                    no_ignore = true,                        
                    hidden = true,                        
                    file_ignore_patterns = { "%.DS_Store", "node_modules/", "%.git/" }
                }
            }
        })
        local builtin = require('telescope.builtin')

        vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Find Files' })
        vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = 'Grep Text' })
        vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'List Buffers' })
    end
}
