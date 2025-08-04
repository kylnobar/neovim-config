-- ~/.config/nvim/lua/plugins/lsp-config.lua
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "lua_ls", "rust_analyzer", "typescript-language-server", "tailwindcss" },
    },
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local cmp_lsp = require("cmp_nvim_lsp")

      -- Extend LSP capabilities for nvim-cmp
      local capabilities = cmp_lsp.default_capabilities()

      -- Custom on_attach for diagnostics and keymaps
      local on_attach = function(client, bufnr)
        vim.diagnostic.config({
          virtual_text = {
            prefix = "●",
            source = "always",
            format = function(diagnostic)
              return string.format("%s: %s", diagnostic.source, diagnostic.message)
            end,
          },
          signs = true,
          update_in_insert = true, -- Show diagnostics while typing
          severity_sort = true,
        })

        -- LSP keymaps
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Go to references" })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code action" })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next diagnostic" })
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Previous diagnostic" })
        vim.keymap.set("n", "<leader>?", vim.lsp.buf.hover, { buffer = bufnr, desc = "Show hover information" }) -- Added
      end

      -- Configure lua_ls
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      -- Configure rust_analyzer
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = { command = "clippy" },
          },
        },
      })

      -- Configure ts_ls for Node.js projects
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        root_dir = lspconfig.util.root_pattern("package.json", "jsconfig.json", ".git"),
        single_file_support = true,
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "mjs" },
        settings = {
          javascript = {
            validate = { enable = true },
            suggestionActions = { enabled = true },
          },
          typescript = {
            validate = { enable = true },
            suggestionActions = { enabled = true },
          },
        },
      })

      -- Configure tailwindcss-language-server
      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "mjs", "jsx" },
        root_dir = lspconfig.util.root_pattern("tailwind.config.js", "tailwind.config.cjs", "package.json", ".git"),
        settings = {
          tailwindCSS = {
            classAttributes = { "class", "className", "ngClass" },
            lint = {
              cssConflict = "warning",
              invalidApply = "error",
              invalidConfigPath = "error",
              invalidScreen = "error",
              invalidTailwindDirective = "error",
              invalidVariant = "error",
              recommendedVariantOrder = "warning",
            },
            validate = true,
          },
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
  },
}
