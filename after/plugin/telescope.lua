local builtin = require('telescope.builtin')

local find_current_session_dir = function()
    if #vim.fn.argv() > 0 then
        return vim.fn.argv()[1]
    end
    return vim.fn.getcwd()
end

vim.keymap.set('n', '<leader>pf', function()
    builtin.find_files(
        { hidden = true, cwd = find_current_session_dir() })
end, {})

vim.keymap.set('n', '<C-p>', builtin.git_files, {})

vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
