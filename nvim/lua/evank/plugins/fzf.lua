return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
        local fzf = require('fzf-lua')
        vim.keymap.set('n', '<leader>ff', fzf.files, {})
        vim.keymap.set('n', '<C-p>', fzf.git_files, {})
        vim.keymap.set('n', '<leader>fs', fzf.live_grep, {})
        vim.keymap.set('n', '<leader>fb', fzf.buffers, {})
        vim.keymap.set('n', '<leader>vh', fzf.helptags, {})
  end
}
