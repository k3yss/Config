local lsp_zero = require('lsp-zero')
local cmp_action = require('lsp-zero').cmp_action()

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
end)

-- Define the devenv_lsp functionality
local devenv_lsp = {}

local find_rust_bin = function()
    return "/home/k3ys/aqua/lsp/target/debug/devenv-nvim-lsp"
end

devenv_lsp.start = function()
    vim.lsp.start({
        name = "devenv-nvim-lsp",
        cmd = { find_rust_bin() },
        root_dir = vim.fs.dirname(vim.fs.find({'devenv.nix'}, { upward = true })[1]),
    })
end

-- Create an augroup instead of a namespace
local group = vim.api.nvim_create_augroup("devenv-nvim-lsp", { clear = true })

devenv_lsp.setup = function ()
    -- No need to clear autocmds manually, the augroup does this automatically
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = {"nix"},
        callback = devenv_lsp.start,
    })
end

-- Setup devenv_lsp
devenv_lsp.setup()


require('lspconfig').rust_analyzer.setup{}
require('lspconfig').pyright.setup{}
require('lspconfig').clangd.setup{}
require('lspconfig').terraformls.setup{}
require('lspconfig').lua_ls.setup{}
--require('lspconfig').nixd.setup({
--   cmd = { "nixd" },
--   settings = {
--      nixd = {
--         nixpkgs = {
--            expr = "import <nixpkgs> { }",
--         },
--         formatting = {
--            command = { "nixpkgs-fmt" },
--         },
--      },
--   },
--})

vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = {"*.tf", "*.tfvars"},
  callback = function()
    vim.lsp.buf.format()
  end,
})

local lsp_configurations = require('lspconfig.configs')

lsp_zero.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = '»'
})

local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
	formatting = {
		format = lspkind.cmp_format(),
	},
	mapping = cmp.mapping.preset.insert({
		['<CR>'] = cmp.mapping.confirm({select = false}),
		['<Tab>'] = cmp_action.luasnip_supertab(),
		['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
		-- ['<C-Space>'] = cmp.mapping.complete(),
	}),
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	preselect = 'item',
	completion = {
		completeopt = 'menu,menuone,noinsert',
	},
})
