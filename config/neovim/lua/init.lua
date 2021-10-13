-- ******************************
-- basic settings
-- ******************************
vim.cmd("set iskeyword+=-") -- treat dash separated words as a word text object"
vim.opt.syntax = "enable" -- syntax highlighting
vim.opt.hidden = true -- allow multiple open buffers
vim.opt.wrap = false -- don"t wrap lines
vim.opt.encoding = "utf-8" -- encoding
vim.opt.fileencoding = "utf-8" -- encoding
vim.opt.ruler = true -- show cursor position
vim.opt.cmdheight = 2 -- make more space for messages
vim.opt.splitbelow = true -- horizontal splits will automatically be below
vim.opt.splitright = true -- vertical splits will automatically be to the right
vim.opt.smartindent = true -- indenting
vim.opt.autoindent = true -- indenting
vim.opt.laststatus = 2 -- always show statusline
vim.opt.number = true -- show line numbers
vim.opt.relativenumber = true -- use relative line numbers
vim.opt.background = "dark" -- tell vim what the background color looks like
vim.opt.backup = false -- don"t backup files
vim.opt.writebackup = false -- don"t backup files
vim.opt.signcolumn = "yes" -- always show the signcolumn, otherwise it would shift the text each time
vim.opt.updatetime = 300 -- faster completion
vim.opt.timeoutlen = 500 -- by default timeoutlen is 1000 ms
vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.incsearch = true -- show search matches while typing
vim.opt.inccommand = "nosplit" -- show result of substitution as you type
vim.opt.mouse = "a"
vim.opt.ts = 2
vim.opt.sw = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.completeopt = "menu,menuone,noselect"

-- don"t automatically add comment on newline
vim.cmd("filetype plugin on") -- need to make sure the autocmd is after this
vim.cmd("autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o")

-- highlight on yank
vim.cmd("augroup yank_highlight")
vim.cmd("autocmd!")
vim.cmd("autocmd TextYankPost *, lua require(\"vim.highlight\").on_yank({higroup = \"Search\", timeout = 200})")
vim.cmd("augroup END")

-- ******************************
-- Basic keybindings
-- ******************************

-- window navigation
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {silent = true})
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {silent = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {silent = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {silent = true})

-- leader
vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', {noremap = true, silent = true})
vim.g.mapleader = ' '

-- escape without the stretch
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', {silent = true, noremap = true})

-- move selected line / block of text in visual mode
-- shift + k to move up
-- shift + j to move down
vim.api.nvim_set_keymap('x', 'K', ":move '<-2<CR>gv-gv", {silent = true, noremap = true})
vim.api.nvim_set_keymap('x', 'J', ":move '<+1<CR>gv-gv", {silent = true, noremap = true})

-- use alt + hjkl to resize windows
vim.api.nvim_set_keymap('n', '<M-j>', ':resize -2<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<M-k>', ':resize +2<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<M-h>', ':vertical resize -2<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<M-l>', ':vertical resize +2<CR>', {silent = true, noremap = true})

-- edit this file
vim.api.nvim_set_keymap('n', '<leader>.', ':e ~/dotfiles.nix/config/neovim/lua/init.lua<cr>', {silent = true, noremap = true})

-- ******************************
-- terminal
-- ******************************
vim.cmd("autocmd TermOpen * setlocal nonumber norelativenumber") -- no line numbers in terminals
vim.cmd("autocmd TermOpen * startinsert") -- switch to insert mode when opening a terminal
vim.cmd("autocmd BufWinEnter,WinEnter term://* startinsert") -- switch to insert mode when entering a terminal
vim.cmd("autocmd TermOpen * setlocal signcolumn=no") -- no sign column in terminals

-- terminal window navigation
vim.api.nvim_set_keymap('t', '<C-h>', '<C-\\><C-N><C-w>h', {silent = true, noremap = true})
vim.api.nvim_set_keymap('t', '<C-j>', '<C-\\><C-N><C-w>j', {silent = true, noremap = true})
vim.api.nvim_set_keymap('t', '<C-k>', '<C-\\><C-N><C-w>k', {silent = true, noremap = true})
vim.api.nvim_set_keymap('t', '<C-l>', '<C-\\><C-N><C-w>l', {silent = true, noremap = true})
vim.api.nvim_set_keymap('i', '<C-h>', '<C-\\><C-N><C-w>h', {silent = true, noremap = true})
vim.api.nvim_set_keymap('i', '<C-j>', '<C-\\><C-N><C-w>j', {silent = true, noremap = true})
vim.api.nvim_set_keymap('i', '<C-k>', '<C-\\><C-N><C-w>k', {silent = true, noremap = true})
vim.api.nvim_set_keymap('i', '<C-l>', '<C-\\><C-N><C-w>l', {silent = true, noremap = true})
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {silent = true, noremap = true})

vim.api.nvim_set_keymap("n", "<leader>t", ":terminal<cr>", {silent = true, noremap = true})

-- ******************************
-- Surround
-- ******************************
require"surround".setup {mappings_style = "surround"}

-- ******************************
-- Registers
-- ******************************
require('nvim-peekup.config').on_keystroke["delay"] = '100ms'

require("indent_blankline").setup {char = "|", buftype_exclude = {"terminal"}}

-- ******************************
-- Project/Tree
-- ******************************
require("nvim-tree").setup {}
require('telescope').load_extension('project')
vim.api.nvim_set_keymap("n", "<leader>p", ":Telescope project<cr>", {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>f", ":NvimTreeFindFile<cr>", {silent = true, noremap = true})

-- ******************************
-- Auto pairs
-- ******************************
require('nvim-autopairs').setup {}

-- ******************************
-- Status line
-- ******************************
local feline_components = require("feline.presets")["default"]
table.insert(feline_components.active[1], {provider = "lsp_client_names", left_sep = " "})
require("feline").setup()

-- ******************************
-- TreeSitter
-- ******************************
require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
    ignore_install = {"haskell"},
    highlight = {enable = true, additional_vim_regex_highlighting = false},
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm"
        }
    },
    indent = {enable = true}
}

-- ******************************
-- Git
-- ******************************
require('gitsigns').setup()

require'diffview'.setup({
    key_bindings = {file_panel = {["q"] = ":DiffviewClose<cr>"}, file_history_panel = {["q"] = ":DiffviewClose<cr>"}}
})

require('neogit').setup({integrations = {diffview = true}})

vim.cmd('augroup neogit_spelling')
vim.cmd('autocmd!')
vim.cmd('autocmd filetype gitcommit set spell')
vim.cmd('augroup END')

vim.api.nvim_set_keymap("n", "<leader>gg", ":Neogit<cr>", {silent = true, noremap = true})

vim.api.nvim_set_keymap("n", "<leader>gh", ":DiffviewFileHistory<cr>", {silent = true, noremap = true})

vim.api.nvim_set_keymap("n", "<leader>gd", ":DiffviewOpen<cr>", {silent = true, noremap = true})

-- ******************************
-- Telescope
-- ******************************
local telescope_actions = require('telescope.actions')
require('telescope').setup {
    defaults = {
        vimgrep_arguments = {
            'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case',
            '--hidden'
        },
        find_command = {
            'rg', '--hidden', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case'
        },
        mappings = {
            i = {
                ["<C-j>"] = telescope_actions.move_selection_next,
                ["<C-k>"] = telescope_actions.move_selection_previous,
                ["<C-q>"] = telescope_actions.smart_send_to_qflist + telescope_actions.open_qflist,
                ["<C-l>"] = telescope_actions.smart_send_to_qflist,
                -- To disable a keymap, put [map] = false
                -- So, to not map "<C-n>", just put
                -- ["<c-x>"] = false,
                ["<esc>"] = telescope_actions.close,

                -- Otherwise, just set the mapping to the function that you want it to be.
                -- ["<C-i>"] = actions.select_horizontal,

                -- Add up multiple actions
                ["<CR>"] = telescope_actions.select_default + telescope_actions.center

                -- You can perform as many actions in a row as you like
                -- ["<CR>"] = actions.select_default + actions.center + my_cool_custom_action,
            },
            n = {
                ["<C-j>"] = telescope_actions.move_selection_next,
                ["<C-k>"] = telescope_actions.move_selection_previous,
                ["<C-q>"] = telescope_actions.smart_send_to_qflist + telescope_actions.open_qflist
                -- ["<C-i>"] = my_cool_custom_action,
            }
        }
    }
}
-- find file
vim.api.nvim_set_keymap("n", "<leader><leader>", ":Telescope find_files hidden=true<cr>", {silent = true, noremap = true})

-- text search
vim.api.nvim_set_keymap("n", "<leader>/", ":Telescope live_grep<cr>", {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>*", ":Telescope grep_string<cr>", {silent = true, noremap = true})

-- buffers
vim.api.nvim_set_keymap("n", "<leader>bb", ":Telescope buffers<cr>", {silent = true, noremap = true})

-- git
vim.api.nvim_set_keymap("n", "<leader>gb", ":Telescope git_branches<cr>", {silent = true, noremap = true})

local cmp = require'cmp'

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'buffer' },
    }
})
