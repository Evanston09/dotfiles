return {
  'stevearc/conform.nvim',
  opts = {
        formatters_by_ft = {
            javascript = { "prettier" },
            typescript = { "prettier" },
            python = { "black" },
        },
    },
    keys = {
        {
            "<leader>cf",
            function()
                require("conform").format({ async = true, lsp_fallback = true })
            end,
            mode = { "n", "v" },
            desc = "Format buffer",
        },
    },
}
