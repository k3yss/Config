local lsp_zero = require('lsp-zero')
local cmp_action = require('lsp-zero').cmp_action()

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require('lspconfig').rust_analyzer.setup{}
require('lspconfig').nixd.setup{}

local lsp_configurations = require('lspconfig.configs')

if not lsp_configurations.qmlls then
  lsp_configurations.qmlls = {
    default_config = {
      name = 'qmlls',
      cmd = {'qmlls'},
      filetypes = {'qml', 'qmljs' },
      root_dir = require('lspconfig.util').root_pattern('README.md')
    }
  }
end

require('lspconfig').qmlls.setup({})

lsp_zero.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = '»'
})

-- to learn how to use mason.nvim
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {},
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
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
