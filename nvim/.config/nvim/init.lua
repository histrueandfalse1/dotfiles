---------- basic config ---------------

-- line numbers
vim.opt.number = true

-- tabs & spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- mouse
vim.opt.mouse = 'a'

-- scroll
vim.opt.scrolloff = 4

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- display
vim.opt.termguicolors = true

-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- performance
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.updatetime = 100
vim.opt.lazyredraw = true
vim.opt.signcolumn = "yes"
vim.opt.cmdheight = 1
vim.opt.timeoutlen = 300

-- window / tabs
vim.opt.splitright = true
vim.opt.laststatus = 3
vim.opt.showmode = false

-- formatting

vim.opt.cinoptions:append("L0") -- allow macros to be indented

-- set function arg, param, etc. indenting to 4 spaces

-- Filetype mapping
vim.filetype.add({
    extension = {
        h = "c",
        c = "c",
        hpp = "cpp",
        cpp = "cpp",
    },
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp" },
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = true
    end,
})

---------- lsp config ----------------

local capabilities = vim.lsp.protocol.make_client_capabilities()
if pcall(require, 'cmp_nvim_lsp') then
    capabilities = require('cmp_nvim_lsp').default_capabilities()
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
    callback = function(args)
        vim.lsp.start({
            name = "clangd",
            cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
            },
            root_dir = vim.fs.root(args.buf, { 'compile_commands.json', 'Makefile', '.clangd' }) or vim.fs.dirname(args.file),
            capabilities = capabilities,
        })
    end,
})

-- diagnostic

vim.diagnostic.config({
    virtual_text = {
        spacing = 4,
        prefix = '»',
    },
    underline = true,
    severity_sort = true,
})

---------- plugin manager --------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--------- plugins ------------

local plugins = {

    -- color theme config
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000, 
        config = function()
            require("gruvbox").setup({
                terminal_colors = true,
                contrast = "hard",
            })
            vim.opt.background = "dark"
            vim.cmd([[colorscheme gruvbox]])
        end
    },

    -- file search
    {
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
    },

    -- code completion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",           
        },
        config = function()
            local cmp = require("cmp")
            
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-e>"] = cmp.mapping.abort(),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },  
                }),
            })
        end
    },

    -- highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter').install({ "c", "cpp", "lua", "vim", "vimdoc" })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "c", "cpp", "lua", "vim", "vimdoc" },
                callback = function()
                    vim.treesitter.start()
                end,
            })
        end
    },

    -- doc generator
    {
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
    },

    -- Statusline
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'gruvbox',
                    component_separators = { left = '>', right = '<' },
                    section_separators = { left = '', right = '' },
                    globalstatus = true,
                    icons_enabled = false, -- Keeps it clean without icon font requirements
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = {
                        'filename',
                        function()
                            -- Safe check to ensure functions don't look for non-existent methods
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
    },
}

require("lazy").setup(plugins)

------------ global keybinds -------------

vim.keymap.set('n', '<leader>r', ':lua vim.lsp.stop_client(vim.lsp.get_clients())<CR>', { silent = true, desc = 'LSP Restart' })
vim.keymap.set("n", "<leader>df", ":lua require('neogen').generate()<CR>", { silent = true })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP Go to Definition' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP Hover Documentation' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP Code Actions' })
