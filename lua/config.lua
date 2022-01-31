require("keymaps")

-- Vim settings
local Opts = {
    number = true,
    showmode = false,
    relativenumber = true,
    list = true,
    smarttab = true,
    smartindent = true,
    softtabstop = 4,
    shiftwidth = 4,
    tabstop = 8,
    mouse = "a",
    guifont = "JetBrains Mono Medium:h8",
    linespace = 0,
    wrap = false,
    colorcolumn = "99999",
    conceallevel = 0,
    splitbelow = true,
    cmdheight = 1,
    scrolloff = 4,
    undodir = vim.fn.stdpath("cache") .. "/undo",
    undofile = true,
    ignorecase = true,
    clipboard = "unnamedplus",
    foldmethod = "manual",
    foldexpr = "",
    splitright = true,
    autoindent = true,
    termguicolors = true,
    cursorline = true,
    updatetime = 500,
    showtabline = 0,
    incsearch = true,
    backup = false,
    writebackup = false,
    expandtab = true,
    swapfile = false,
    timeoutlen = 400,
    sidescrolloff = 4,
    hidden = true, -- required to keep multiple buffers and open multiple buffers
    hlsearch = true,
    pumheight = 20, -- pop up menu height
    smartcase = true,
    title = true,
    numberwidth = 4,
    signcolumn = "yes",
    completeopt = "menuone,noselect",
    sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal",
}

local globals = {
    transparrent = false,
    term_in_insert = true,
    always_show_bufferline = true,
    format_on_save = true,

    -- Neovide config
    neovide_transparency = 0.9,
    neovide_remember_window_size = true,
    neovide_cursor_vfx_mode = "torpedo",
    neovide_cursor_vfx_particle_lifetime = 4.2,
    neovide_floating_opacity = 0.7,
    neovide_no_idle = true,
    -- neovide_opacity = 0.8,
    neovide_cursor_vfx_particle_phase = 2.5,
    neovide_cursor_vfx_particle_density = 8.0,
    neovide_floating_blur = 1,
    neovide_input_use_logo = true,
}

vim.opt.shortmess:append("c")

for i, v in pairs(Opts) do
    vim.opt[i] = v
end
for i, v in pairs(globals) do
    vim.g[i] = v
end

vim.highlight.on_yank({ on_visual = true })

if vim.g.transparrent == true then
    vim.cmd("au ColorScheme * hi Normal ctermbg=none guibg=none")
    vim.cmd("au ColorScheme * hi SignColumn ctermbg=none guibg=none")
    vim.cmd("au ColorScheme * hi NormalNC ctermbg=none guibg=none")
    vim.cmd("au ColorScheme * hi MsgArea ctermbg=none guibg=none")
    vim.cmd("au ColorScheme * hi TelescopeBorder ctermbg=none guibg=none")
    vim.cmd("au ColorScheme * hi NvimTreeNormal ctermbg=none guibg=none")
    vim.cmd("au ColorScheme * hi EndOfBuffer ctermbg=none guibg=none")
    vim.cmd("au ColorScheme * hi BufferLineSeprator guibg='#222'")
end

require("neoscroll").setup()
require("conf")
require("todo-comments").setup()
require("nvim-tree").setup(vim.g.nvimTreeConfig.setup)
require("onedark").load()

vim.cmd([[ highlight NvimTreeFolderIcon guifg=#0f9cfe ]])
-- Session manager
local Path = require("plenary.path")
require("session_manager").setup({
    sessions_dir = Path:new(vim.fn.stdpath("data"), "sessions"),
    path_replacer = "__",
    colon_replacer = "++",
    autoload_mode = "Disabled",
    autosave_last_session = false,
    autosave_ignore_not_normal = true,
})



