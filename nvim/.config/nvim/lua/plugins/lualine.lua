return {
    'nvim-lualine/lualine.nvim',
    config = function()
        require('lualine').setup({
            options = {
                theme = 'gruvbox',
                component_separators = { left = '>', right = '<' },
                section_separators = { left = '', right = '' },
                globalstatus = true,
                icons_enabled = false,
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = {
                    'filename',
                    function()
                        if vim.fn.exists('*nvim_treesitter#statusline') == 1 then
                            return vim.fn['nvim_treesitter#statusline'](180)
                        end
                        return ''
                    end
                },
                lualine_x = { 
                    'encoding', 
                    {
                        function()
                            return vim.bo.filetype
                        end
                    }
                },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
        })
    end
}
