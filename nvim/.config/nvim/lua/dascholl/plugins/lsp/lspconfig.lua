return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import mason_lspconfig plugin
    local mason_lspconfig = require("mason-lspconfig")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    mason_lspconfig.setup_handlers({
      -- default handler for installed servers
      function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
          root_dir = function()
            return vim.loop.cwd()
          end,
        })
      end,
      ["svelte"] = function()
        -- configure svelte server
        lspconfig["svelte"].setup({
          capabilities = capabilities,
          root_dir = function()
            return vim.loop.cwd()
          end,
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePost", {
              pattern = { "*.js", "*.ts" },
              callback = function(ctx)
                client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
              end,
            })
          end,
        })
      end,
      ["graphql"] = function()
        -- configure graphql language server
        lspconfig["graphql"].setup({
          capabilities = capabilities,
          root_dir = function()
            return vim.loop.cwd()
          end,
          filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
        })
      end,
      ["emmet_ls"] = function()
        -- configure emmet language server
        lspconfig["emmet_ls"].setup({
          capabilities = capabilities,
          root_dir = function()
            return vim.loop.cwd()
          end,
          filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
        })
      end,
      ["lua_ls"] = function()
        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
          capabilities = capabilities,
          root_dir = function()
            return vim.loop.cwd()
          end,
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        })
      end,
      ["yamlls"] = function()
        lspconfig.yamlls.setup({
          capabilities = capabilities,
          root_dir = function()
            return vim.loop.cwd()
          end,
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
              },
              schemas = {
                ["https://raw.githubusercontent.com/fluxcd-community/flux2-schemas/main/helmrelease-helm-v2beta1.json"] = {
                  "**/helmrelease.yaml",
                  "**/release.yaml",
                  "**/*-release.yaml",
                  "**/*.{yaml,yml}",
                },
                ["https://raw.githubusercontent.com/fluxcd-community/flux2-schemas/main/kustomization-kustomize-v1beta2.json"] = "**/kustomization.yaml",
                ["https://raw.githubusercontent.com/fluxcd-community/flux2-schemas/main/gitrepository-source-v1beta2.json"] = "**/gitrepository.yaml",
                ["https://raw.githubusercontent.com/fluxcd-community/flux2-schemas/main/helmrepository-source-v1beta2.json"] = "**/helmrepository.yaml",
                ["https://raw.githubusercontent.com/fluxcd-community/flux2-schemas/main/bucket-source-v1beta2.json"] = "**/bucket.yaml",
                ["https://raw.githubusercontent.com/fluxcd-community/flux2-schemas/main/alert-notification-v1beta2.json"] = "**/alert.yaml",
                ["https://raw.githubusercontent.com/fluxcd-community/flux2-schemas/main/provider-notification-v1beta2.json"] = "**/provider.yaml",
                ["https://raw.githubusercontent.com/fluxcd-community/flux2-schemas/main/receiver-notification-v1beta2.json"] = "**/receiver.yaml",

                kubernetes = {
                  "k8s/**/*.{yml,yaml}",
                  "kubernetes/**/*.{yml,yaml}",
                },
              },
              format = { enable = true },
              validate = true,
              completion = true,
              hover = true,
              keyOrdering = false,
              customTags = {
                "!reference sequence",
                "!include_dir_merge_list",
                "!include_dir_merge_named",
              },
              schemaValidation = false,
              validateDuplicateKey = false,
              maxItemsComputed = 10000,
              editor = {
                tabSize = 2,
                formatOnType = false,
              },
              disableDefaultProperties = true,
              disableAdditionalProperties = true,
              documents = {
                ignoreMultiDocument = false,
                provider = true
              }
            },
          },
          flags = {
            debounce_text_changes = 150,
          },
        })
      end,
    })
  end,
}

