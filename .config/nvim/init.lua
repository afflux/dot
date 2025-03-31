local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })

end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  'tpope/vim-surround',
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  {
    'morhetz/gruvbox',
    lazy = false,
    priority = 1000,
    config = function(plugin, opts)
      vim.g.gruvbox_italic = 1
      vim.cmd.colorscheme("gruvbox")
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = 'nvim-treesitter.configs',
    opts = {
        highlight = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn", -- set to `false` to disable one of the mappings
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        indent = {
          enable = false, -- 2024-08-08: treesitter indent is terrible on python
        },
      },

    init = function(plugin)
      vim.o.foldmethod = "expr"
      vim.o.foldexpr = "nvim_treesitter#foldexpr()"
      vim.o.foldenable = false
    end,
  },
  {
    'stevearc/aerial.nvim',
    opts = {},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    init = function(plugin)
      vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = { theme = 'gruvbox' },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  {
    "neovim/nvim-lspconfig", -- REQUIRED: for native Neovim LSP integration
    lazy = false, -- REQUIRED: tell lazy.nvim to start this plugin at startup
    dependencies = {
      -- main one
      { "ms-jpq/coq_nvim", branch = "coq" },

      -- 9000+ Snippets
      { "ms-jpq/coq.artifacts", branch = "artifacts" },
    },
    init = function()
      vim.g.coq_settings = {
          auto_start = "shut-up", -- if you want to start COQ at startup
          -- Your COQ settings here
      }
    end,
    config = function()
      -- Your LSP settings here
      require'lspconfig'.rust_analyzer.setup{}
      require'lspconfig'.ruff.setup{}
      -- TODO add lsp keybindings
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

            local bufopts = function(desc)
                return { noremap = true, silent = true, buffer = ev.buf, desc = desc }
            end
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts('Go to Declaration'))
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts('Go to Definition'))
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts('Hover'))
            vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, bufopts('Go to Implementation'))
            vim.keymap.set('n', '<Leader>k', vim.lsp.buf.signature_help, bufopts('Singature Help'))
            vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, bufopts('Add Workspace Folder'))
            vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts('Remove Workspace Folder'))
            vim.keymap.set('n', '<Leader>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, bufopts('List Workspace Folder'))
            vim.keymap.set('n', '<Leader>t', vim.lsp.buf.type_definition, bufopts('Type Definition'))
            vim.keymap.set('n', '<Leader>r', vim.lsp.buf.rename, bufopts('Rename with LSP'))
            vim.keymap.set({ 'n', 'v' }, '<Leader>p', vim.lsp.buf.code_action, bufopts('Code Action'))
            vim.keymap.set('n', 'gR', vim.lsp.buf.references, bufopts('Go to Reference'))
            vim.keymap.set('n', '<Leader>f', function() vim.lsp.buf.format({ async = true }) end, bufopts('Formatting with LSP'))

            -- Get client
            local client = vim.lsp.get_client_by_id(ev.data.client_id)

            -- ╭─────────────╮
            -- │ INLAY HINTS │
            -- ╰─────────────╯
            if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(true)
            else
                vim.lsp.inlay_hint.enable(false)
            end
        end,
    })
    end,
  }
}, opts)


vim.api.nvim_create_autocmd({"BufReadPost"}, {
    pattern = {"*"},
    callback = function()
        if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
          vim.cmd("normal! g'\"")
        end
    end
})

-- smaller-than-default file browser window, minus for absolute column width
vim.g.netrw_winsize = -40

vim.o.foldlevel = 9999
vim.o.cmdheight = 2
vim.o.termguicolors = true
vim.o.number = true
vim.o.cursorline = true
vim.o.mouse = "vn"

vim.o.title = true
vim.o.titleold = ""

-- not using the "normal" way to configure osc52 as pasting is not reliably
-- possible most terminals disable pasting by default, if they implement it
-- at all.
-- here we use the default clipboard implementation (xclip, tmux, ...) and
-- additionally yank to osc52
vim.o.clipboard = "unnamedplus"

local osc52 = require('vim.ui.clipboard.osc52')
vim.api.nvim_create_autocmd('TextYankPost', { callback = function ()
  local reg = vim.v.event.regname
  if reg == '' then
    reg = '+'
  end
  if vim.v.event.operator == 'y' and (reg == '+' or reg == '*') then
    vim.highlight.on_yank()
    osc52.copy(reg)(vim.v.event.regcontents)
  end
end
})

-- block selection on Alt-LeftMouse
vim.keymap.set({"i", "n", "v"}, "<M-LeftMouse>", "<4-LeftMouse>", {noremap = true})
vim.keymap.set("o", "<M-LeftMouse>", "<C-C><4-LeftMouse>", {noremap = true})
vim.keymap.set({"i", "n", "v"}, "<M-LeftDrag>", "<4-LeftDrag>", {noremap = true})
vim.keymap.set("o", "<M-LeftDrag>", "<C-C><4-LeftDrag>", {noremap = true})

vim.keymap.set("n", "<F4>", function() vim.o.relativenumber = not(vim.o.relativenumber) end, {noremap = true})

-- close quickfix / location / preview windows
vim.keymap.set("n", "<Leader>c", ":cclose | lclose | pclose | AerialCloseAll<CR>", {noremap = true})

-- open netrw explorer on F3
vim.g.netrw_liststyle = 3
vim.keymap.set('n', '<F3>', function()
  for _, window in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_get_option_value("filetype", {buf = vim.fn.winbufnr(window)}) == "netrw" then
      vim.api.nvim_win_close(window, false)
      return
    end
  end

  vim.cmd(":Lexplore")
end,
  {noremap = true})

vim.keymap.set('n', '<S-F3>', function()
  for _, window in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_get_option_value("filetype", {buf = vim.fn.winbufnr(window)}) == "netrw" then
      vim.api.nvim_win_close(window, false)
      return
    end
  end

  local dir = vim.fn.expand("%:p:h")
  vim.fn.setreg("/", vim.fn.expand("%:t"))
  vim.cmd(":Lexplore " .. dir)
  vim.cmd(":silent normal n<CR>zz")
end,
  {noremap = true})

-- revert to old behavior - always open the edit conflict dialog
vim.api.nvim_clear_autocmds({group = "nvim_swapfile"})
-- vim:ts=2:sts=2:sw=2:et
