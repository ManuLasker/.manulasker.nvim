local builtin = require('telescope.builtin')


vim.keymap.set('n', '<leader>pf', function()
    builtin.find_files(
        { hidden = true, no_ignore = true, no_ignore_parent = true } )
end, {})

vim.keymap.set('n', '<C-p>', builtin.git_files, {})

vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
