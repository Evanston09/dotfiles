return {
  "sindrets/diffview.nvim",
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Open Git diff" },
    { "<leader>gc", "<cmd>DiffviewClose<CR>", desc = "Close Git diff" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "Current file Git history" },
  },
  opts = function()
    local actions = require("diffview.actions")
    return {
      keymaps = {
        file_panel = {
          -- flash/oil use these keybinds
          { "n", "s", false },
          { "n", "S", false },
          { "n", "-", false },
          { "n", "<leader>gs", actions.toggle_stage_entry, { desc = "Stage / unstage selected entry" } },
          { "n", "<leader>gS", actions.stage_all, { desc = "Stage all entries" } },
          { "n", "<leader>gu", actions.unstage_all, { desc = "Unstage all entries" } },
        },
      },
    }
  end,
}
