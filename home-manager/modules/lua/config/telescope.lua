local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
-- vim.keymap.set('n', '<leader>s', function()
--	builtin.grep_string({ search = vim.fn.input("Grep > ") })
-- end)

-- vim.keymap.set('n', '<leader>s', builtin.live_grep, {})

vim.keymap.set("n", "<leader>s", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")


local actions = require("telescope.actions")

require("telescope").load_extension("live_grep_args")


require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close,
            },
        },
    },
})

vim.cmd([[
    autocmd User TelescopePreviewerLoaded setlocal wrap
]])
