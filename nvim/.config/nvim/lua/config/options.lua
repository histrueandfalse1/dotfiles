-- Line numbers
vim.opt.number = true

-- Tabs & Spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- UI & Mouse
vim.opt.mouse = 'a'
vim.opt.scrolloff = 4
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cmdheight = 1
vim.opt.splitright = true
vim.opt.laststatus = 3
vim.opt.showmode = false

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Performance & History
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.updatetime = 100
vim.opt.lazyredraw = true
vim.opt.timeoutlen = 300

-- Formatting options
vim.opt.cinoptions:append("L0")

-- Filetype extensions
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
