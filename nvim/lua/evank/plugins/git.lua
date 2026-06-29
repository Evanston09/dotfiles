return {
  "NeogitOrg/neogit",
  lazy = true,
  dependencies = {
    "sindrets/diffview.nvim",        -- optional

    -- For a custom log pager
    "m00qek/baleia.nvim",            -- optional

    "ibhagwan/fzf-lua",              -- optional
  },
  cmd = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
  },
  opts = {
      kind = "replace",
  }
}
