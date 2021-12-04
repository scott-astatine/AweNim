-- Colorscheme config
vim.g.onedark_transparrent_background = true
vim.g.onedark_style = 'warmer'
vim.g.onedark_italic_comment = true

require('neoscroll').setup()
require('onedark').setup()
require('conf')
require("todo-comments").setup()

-- Session manager
local Path = require('plenary.path')
require('session_manager').setup({
  sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'),
  path_replacer = '__', -- The character to which the path separator will be replaced for session files.
  colon_replacer = '++', -- The character to which the colon symbol will be replaced for session files.
  autoload_mode = "Disabled", -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
  autosave_last_session = false, -- Automatically save last session on exit.
  autosave_ignore_not_normal = true, -- Plugin will not save a session when no writable and listed buffers are opened.
})

-- Vim settings
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.guifont = 'JetBrains Mono:h9'
vim.o.wrap = false
vim.o.smarttab = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.showtabline = 2
vim.g.clipboard = {
  name = 'CopyQ',
  copy = {
    ['+'] = { 'copyq', 'add', '-' },
    ['*'] = { 'copyq', 'add', '-' }
  },
  paste = {
    ['+'] = { 'copyq', 'paste', '-' },
    ['*'] = { 'copyq', 'paste', '-' }
  }
}
vim.o.incsearch = true
vim.o.backup = false
vim.o.writebackup = false
vim.o.expandtab = true
vim.g.transparrent = false
vim.o.showmode = false
vim.highlight.on_yank { on_visual = true }

-- Neovide config
vim.g.neovide_transparency = 0.8
vim.g.neovide_remember_window_size = 1
vim.g.neovide_cursor_vfx_mode = "torpedo"
vim.g.neovide_cursor_vfx_particle_lifetime = 3.2
vim.g.neovide_floating_opacity = 0.6
vim.g.neovide_no_idle = true
vim.g.neovide_opacity = 0.8
vim.g.neovide_cursor_vfx_particle_phase = 1.5
vim.g.neovide_cursor_vfx_particle_density = 7.0
vim.g.neovide_floating_blur = 1
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})

local signs = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " "
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

function PrintDiagnostics(opts, bufnr, line_nr, client_id)
  opts = opts or {}

  bufnr = bufnr or 0
  line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)

  local line_diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr, line_nr, opts, client_id)
  if vim.tbl_isempty(line_diagnostics) then return end

  local diagnostic_message = ""
  for i, diagnostic in ipairs(line_diagnostics) do
    diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
    print(diagnostic_message)
    if i ~= #line_diagnostics then
      diagnostic_message = diagnostic_message .. "\n"
    end
  end
  vim.api.nvim_echo({{diagnostic_message, "Normal"}}, false, {})
end

vim.cmd [[ autocmd CursorHold * lua PrintDiagnostics() ]]

if vim.g.transparrent then
  vim.api.nvim_command('highlight Normal guibg=NONE ctermbg=NONE')
  vim.api.nvim_command('highlight NonText guibg=NONE ctermbg=NONE')
  vim.api.nvim_command('highlight EndOfBuffer guibg=NONE ctermbg=NONE')
end


--- Bdelete to close buffer without exiting nvim
vim.cmd(
[[
    if exists("g:loaded_bbye") || &cp | finish | endif
    let g:loaded_bbye = 1

    function! s:bdelete(action, bang, buffer_name)
            let buffer = s:str2bufnr(a:buffer_name)
            let w:bbye_back = 1

            if buffer < 0
                    return s:error("E516: No buffers were deleted. No match for ".a:buffer_name)
            endif

            if getbufvar(buffer, "&modified") && empty(a:bang)
                    let error = "E89: No write since last change for buffer "
                    return s:error(error . buffer . " (add ! to override)")
            endif

            if getbufvar(buffer, "&modified") && !empty(a:bang)
                    call setbufvar(buffer, "&bufhidden", "hide")
            endif

            for window in reverse(range(1, winnr("$")))
                    if winbufnr(window) != buffer | continue | endif
                    execute window . "wincmd w"

                    try | exe bufnr("#") > 0 && buflisted(bufnr("#")) ? "buffer #" : "bprevious"
                    catch /^Vim([^)]*):E85:/ " E85: There is no listed buffer
                    endtry

                    if bufnr("%") != buffer | continue | endif

                    call s:new(a:bang)
            endfor

            let back = filter(range(1, winnr("$")), "getwinvar(v:val, 'bbye_back')")[0]
            if back | exe back . "wincmd w" | unlet w:bbye_back | endif

            if buflisted(buffer) && buffer != bufnr("%")
                    exe a:action . a:bang . " " . buffer
            endif
    endfunction

    function! s:str2bufnr(buffer)
            if empty(a:buffer)
                    return bufnr("%")
            elseif a:buffer =~# '^\d\+$'
                    return bufnr(str2nr(a:buffer))
            else
                    return bufnr(a:buffer)
            endif
    endfunction

    function! s:new(bang)
            exe "enew" . a:bang

            setl noswapfile
            setl bufhidden=wipe
            setl buftype=
            setl nobuflisted
    endfunction

    function! s:error(msg)
            echohl ErrorMsg
            echomsg a:msg
            echohl NONE
            let v:errmsg = a:msg
    endfunction

    command! -bang -complete=buffer -nargs=? Bdelete
            \ :call s:bdelete("bdelete", <q-bang>, <q-args>)

    command! -bang -complete=buffer -nargs=? Bwipeout
            \ :call s:bdelete("bwipeout", <q-bang>, <q-args>)

]]
)


