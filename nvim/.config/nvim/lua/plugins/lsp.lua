return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        if pcall(require, 'cmp_nvim_lsp') then
            capabilities = require('cmp_nvim_lsp').default_capabilities()
        end

        -- 1. Apply global defaults (capabilities, etc.) across all LSPs
        vim.lsp.config('*', {
            capabilities = capabilities,
        })

        -- 2. Add custom server settings if needed (e.g. clangd flags)
        vim.lsp.config('clangd', {
            cmd = { "clangd", "--background-index", "--clang-tidy" },
        })

        -- 3. Enable language servers using Neovim 0.11+ native API
        local servers = { "clangd", "pyright", "lua_ls", "rust_analyzer", "gopls" }

        for _, server in ipairs(servers) do
            vim.lsp.enable(server)
        end
    end,
}
