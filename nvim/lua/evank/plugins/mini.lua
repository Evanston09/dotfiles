return {
    "nvim-mini/mini.nvim",
    version = false, -- use main branch; use version = "*" for stable
    config = function()
        require("mini.ai").setup()
        require("mini.surround").setup()
        require("mini.pairs").setup()
        require("mini.splitjoin").setup()
        require("mini.move").setup()
    end,
}
