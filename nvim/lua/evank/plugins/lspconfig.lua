return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'saghen/blink.cmp',
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function ()
        require("mason").setup()
        require("mason-lspconfig").setup()

        local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
        require("mason-lspconfig").setup_handlers {
            -- The first entry (without a key) will be the default handler
            -- and will be called for each installed server that doesn't have
            -- a dedicated handler.
            function (server_name) -- default handler (optional)
                require("lspconfig")[server_name].setup {capabilities = capabilities}
            end,
        }
    end
}
