return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("nvim-treesitter.configs").setup({
      -- Ensure parsers for JSX/TSX are installed
      ensure_installed = {
        "javascript",
        "tsx",
        "typescript",
        "html",
        "css",
        "json",
      },
      -- Enable syntax highlighting
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false, -- Avoid conflicts with Treesitter highlighting
      },
      -- Enable indentation
      indent = {
        enable = true,
      },
      -- Enable autotagging for ts-autotag.nvim
      autotag = {
        enable = true,
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
        filetypes = {
          "html",
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "svelte",
          "vue",
          "tsx",
          "jsx",
          "xml",
        },
      },
      -- Ensure JSX/TSX filetypes are recognized
      filetype_to_parsername = {
        javascriptreact = "tsx",
        typescriptreact = "tsx",
        jsx = "tsx",
        tsx = "tsx",
      },
    })
  end,
}
