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
          enable = true
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

}, opts)


vim.api.nvim_create_autocmd({"BufReadPost"}, {
    pattern = {"*"},
    callback = function()
        if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
          vim.cmd("normal! g'\"")
        end
    end
})

-- smaller-than-default file browser window
vim.g.netrw_winsize = 25

vim.o.cmdheight = 2
vim.o.termguicolors = true
vim.o.number = true
vim.o.cursorline = true
vim.o.mouse = "vn"

vim.o.title = true
vim.o.titleold = ""

-- disable search highlight if moved away
vim.api.nvim_create_autocmd('CursorMoved', {
  group = vim.api.nvim_create_augroup('auto-hlsearch', { clear = true }),
  callback = function ()
    if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
      vim.schedule(function () vim.cmd.nohlsearch() end)
    end
  end
})

-- not using the "normal" way to configure osc52 as pasting is not reliably
-- possible most terminals disable pasting by default, if they implement it
-- at all.
-- here we use the default clipboard implementation (xclip, tmux, ...) and
-- additionally yank to osc52 
vim.o.clipboard = "unnamedplus"

local osc52 = require('vim.ui.clipboard.osc52') 
vim.api.nvim_create_autocmd('TextYankPost', { callback = function ()
  local reg = vim.v.event.regname
  if vim.v.event.operator == 'y' and (reg == '' or reg == '+' or reg == '*') then
    osc52.copy(reg)
  end
end
})

-- block selection on Alt-LeftMouse
vim.keymap.set({"i", "n", "v"}, "<M-LeftMouse>", "<4-LeftMouse>", {noremap = true})
vim.keymap.set("o", "<M-LeftMouse>", "<C-C><4-LeftMouse>", {noremap = true})
vim.keymap.set({"i", "n", "v"}, "<M-LeftDrag>", "<4-LeftDrag>", {noremap = true})
vim.keymap.set("o", "<M-LeftDrag>", "<C-C><4-LeftDrag>", {noremap = true})

vim.keymap.set("n", "<F4>", function() vim.o.relativenumber = not(vim.o.relativenumber) end, {noremap = true})
-- open netrw explorer on F3
vim.keymap.set("n", "<F3>", ":Lexplore<CR>", {noremap = true})

-- revert to old behavior - always open the edit conflict dialog
vim.api.nvim_clear_autocmds({group = "nvim_swapfile"})
