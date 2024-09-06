local M = {}

local find_rust_bin = function()
	return "/home/k3ys/aqua/lsp/target/debug/devenv-nvim-lsp"
end

M.start = function()
	vim.lsp.start({
		name = "devenv-nvim-lsp",
		cmd = { find_rust_bin() },
		root_dir = vim.fs.dirname(vim.fs.find({'devenv.nix'}, { upward = true })[1]),
	})
end

local group = vim.api.nvim_create_namespace("devenv-nvim-lsp")
M.setup = function ()
	vim.api.nvim_clear_autocmds({group = group})
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = {"nix"},
		callback = M.start,
	})
end

return M
