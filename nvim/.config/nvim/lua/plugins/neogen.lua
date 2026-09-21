return {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
        require('neogen').setup({
            enabled = true,
            languages = {
                cpp = {
                    template = {
                        annotation_type = "doxygen"
                    }
                }
            }
        })
    end,
}
