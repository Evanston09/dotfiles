vim.g.mapleader = " "

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    local opts = { buffer = bufnr, silent = true, noremap = true }

    vim.keymap.set("n", "K",  vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  end,
})
