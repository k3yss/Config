local lsp_zero = require('lsp-zero')
local cmp_action = require('lsp-zero').cmp_action()

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
end)

-- Define the devenv_lsp functionality
local devenv_lsp = {}

local function find_rust_bin()
    local bin = "/home/k3ys/sandbox/cachix/devenv/target/debug/devenv"
    if vim.fn.executable(bin) == 1 then
        return bin
    else
        error("devenv binary not found")
    end
end

local function find_root_dir(fname)
    local root = vim.fs.dirname(vim.fs.find({'devenv.nix'}, { upward = true, path = fname })[1])
    return root or vim.fn.getcwd()
end

devenv_lsp.start = function()
    local root_dir = find_root_dir(vim.fn.expand('%:p'))
    local client = vim.lsp.start({
        name = "devenv-lsp",
        cmd = { find_rust_bin(), "lsp" },
        root_dir = root_dir,
		cmd_env = { DEVENV_NIX = "/nix/store/l3zdaaps1f12638bgrx8l69l9jpdh1hn-nix-devenv-2.24.0pre20240927_f6c5ae4" }
    })
    if not client then
        vim.notify("Failed to start devenv LSP", vim.log.levels.ERROR)
    end
end

local group = vim.api.nvim_create_augroup("devenv-lsp", { clear = true })

devenv_lsp.setup = function ()
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = {"nix"},
        callback = function()
            pcall(devenv_lsp.start)
        end,
    })
end

devenv_lsp.setup()

require('lspconfig').rust_analyzer.setup{}
require('lspconfig').pyright.setup{}
require('lspconfig').clangd.setup{}
require('lspconfig').terraformls.setup{}
require('lspconfig').zls.setup{}
-- require('lspconfig').lua_ls.setup{}
require('lspconfig').gopls.setup{}
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
