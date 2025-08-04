return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" }, -- Load on file open
  opts = {
    formatters_by_ft = {
      html = { "prettier" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      lua = { "stylua" },
      json = { "prettier" },
      css = { "prettier" },
      ["*"] = { "trim_whitespace" }, -- Trim whitespace for all filetypes
    },
    formatters = {
      prettier = {
        prepend_args = { "--single-quote", "--trailing-comma", "es5" },
      },
    },
  },
  config = function(_, opts)
    local conform = require("conform")
    conform.setup(opts)
    -- Map <leader>fm to format the current buffer
    vim.keymap.set({ "n", "v" }, "<leader>fm", function()
      conform.format({
        async = true,
        lsp_fallback = true,
      })
    end, { desc = "Format buffer" })
  end,
}
