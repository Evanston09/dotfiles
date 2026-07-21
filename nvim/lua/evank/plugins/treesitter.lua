return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",

    config = function()
      local treesitter = require("nvim-treesitter")

      treesitter.install({
        -- Programming languages
        "python",
        "css",
        "html",
        "javascript",
        "typescript",
        "tsx",
        "php",
        "rust",
        "go",
        "cpp",
        "c",

        -- Configuration and project files
        "dockerfile",
        "yaml",
        "gitignore",
        "toml",

        -- Useful Neovim/config parsers
        "lua",
        "vim",
        "vimdoc",
        "query",
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}

