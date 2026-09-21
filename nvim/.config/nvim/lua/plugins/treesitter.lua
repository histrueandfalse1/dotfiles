return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
        require('nvim-treesitter').install({ "c", "cpp", "lua", "vim", "vimdoc"})
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "c", "cpp", "lua", "vim", "vimdoc"},
            callback = function()
                vim.treesitter.start()
            end,
        })
    end
}
