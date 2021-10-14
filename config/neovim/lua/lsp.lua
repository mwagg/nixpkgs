local lspconfig = require "lspconfig"

-- ******************************
-- LSP config
-- ******************************
require'lspsaga'.init_lsp_saga({
    code_action_keys = {quit = '<esc>', exec = '<CR>'},
    finder_action_keys = {
        open = '<cr>',
        vsplit = 's',
        split = 'i',
        quit = '<esc>',
        scroll_down = '<C-f>',
        scroll_up = '<C-b>'
    }
})

-- ******************************
-- LSP servers
-- ******************************
local common_on_attach = function(_, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    -- Mappings.
    local opts = {noremap = true, silent = true}

    buf_set_keymap('n', '<leader>ca', "<cmd>lua require('lspsaga.codeaction').code_action()<cr>", opts)
    buf_set_keymap('n', 'K', "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", opts)
    buf_set_keymap('n', '<leader>cr', "<cmd>lua require('lspsaga.rename').rename()<CR>", opts)
    buf_set_keymap('n', '[e', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>", opts)
    buf_set_keymap('n', ']e', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>", opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    buf_set_keymap('n', '<leader>ch', "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>", opts)
end

local configure_format_on_save = function(name, file_types)
    vim.cmd("augroup autoformat_" .. name)
    vim.cmd("autocmd!")
    for _, file_type in pairs(file_types) do
        vim.cmd("autocmd BufWritePre " .. file_type .. " lua vim.lsp.buf.formatting()")
    end
    vim.cmd("augroup END")
end

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- ** Lua **
configure_format_on_save("lua", {"*.lua"})

--  ** Nix **
lspconfig.rnix.setup({capabilities = capabilities, cmd = {"@rnix_lsp@/bin/rnix-lsp"}, on_attach = common_on_attach})
configure_format_on_save("Nix", {"*.nix"})

-- ** Terraform **
lspconfig.terraformls.setup({
    cmd = {"@terraform_ls@/bin/terraform-ls", "serve"},
    capabilities = capabilities,
    on_attach = common_on_attach
})
configure_format_on_save("terraform", {"*.tf"})

-- ** YAML **
lspconfig.yamlls.setup({
    cmd = {"@yaml_ls@/bin/yaml-language-server", "--stdio"},
    capabilities = capabilities,
    on_attach = common_on_attach
})

-- ** Typescript **
local function tsserver_on_attach(client, bufnr)
    common_on_attach(client, bufnr)
    client.resolved_capabilities.document_formatting = false
end

lspconfig.tsserver.setup({
    capabilities = capabilities,
    cmd = {"@ts_ls@/bin/typescript-language-server", "--stdio"},
    filetypes = {"javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx"},
    root_dir = require('lspconfig/util').root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
    settings = {documentFormatting = false},
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = {spacing = 0, prefix = ""},
            signs = true,
            underline = true,
            update_in_insert = true
        })
    },
    on_attach = tsserver_on_attach
})
configure_format_on_save("typescript", {"*.js", "*.jsx", "*.ts", "*.tsx"})

-- ** EFM **
local prettier = {formatCommand = "@prettier@/lib/node_modules/prettier --stdin-filepath ${INPUT}", formatStdin = true}
local tsserver_args = {
    {formatCommand = "@prettier@/bin/prettier --stdin-filepath ${INPUT}", formatStdin = true}, {
        formatCommand = "@eslint@/bin/eslint --fix-to-stdout --stdin --stdin-filename=${INPUT}",
        formatStdin = true,
        lintCommand = "@eslint@/bin/eslint -f unix --stdin --stdin-filename ${INPUT}",
        lintFormats = {"%f:%l:%c: %m"},
        lintIgnoreExitCode = true,
        lintStdin = true
    }
}
lspconfig.efm.setup({
    cmd = {"@efm@/bin/efm-langserver"},
    capabilities = capabilities,
    init_options = {documentFormatting = true, codeAction = false},
    filetypes = {
        "lua", "python", "javascriptreact", "javascript", "typescript", "typescriptreact", "sh", "html", "css", "json",
        "yaml", "markdown", "vue"
    },
    settings = {
        rootMarkers = {".git/"},
        languages = {
            --[[ python = {
                {
                    LintCommand = "flake8 --ignore=E501 --stdin-display-name ${INPUT} -",
                    lintFormats = {"%f:%l:%c: %m"},
                    lintStdin = true
                }, {
                    formatCommand = "isort --quiet -",
                    formatStdin = true
                }, {
                    formatCommand = "black --quiet -",
                    formatStdin = true
                }
            }, ]]
            lua = {
                {
                    formatCommand = "@luaformat@/bin/lua-format -i --no-keep-simple-function-one-line --column-limit=120",
                    formatStdin = true
                }
            },
            sh = {
                {formatCommand = "@shfmt@/bin/shfmt -ci -s -bn", formatStdin = true}, {
                    LintCommand = "@shellcheck@/bin/shellcheck -f gcc -x",
                    lintFormats = {"%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m"}
                }
            },
            javascript = tsserver_args,
            javascriptreact = tsserver_args,
            typescript = tsserver_args,
            typescriptreact = tsserver_args,
            html = {prettier},
            css = {prettier},
            json = {prettier},
            yaml = {prettier}
        }
    }
})

-- ** Ruby **
lspconfig.solargraph.setup({
    cmd = {"@solargraph@/bin/solargraph", "stdio"},
    capabilities = capabilities,
    settings = {solargraph = {autoformat = true}},
    on_attach = common_on_attach
})

lspconfig.sorbet.setup({capabilities = capabilities, on_attach = common_on_attach})

configure_format_on_save("Ruby", {"*.rb"})

-- ** Elm **
lspconfig.elmls.setup({
    capabilities = capabilities,
    on_attach = common_on_attach,
    cmd={"@elm@/bin/elm-language-server"},
})

-- ** Lua **
--[[ lspconfig.sumneko_lua.setup({
  capabilities = capabilities,
  cmd = { "@sumneko_lua_language_server@/bin/lua-language-server" },
  root_dir = lspconfig.util.find_git_ancestor,
  on_attach = common_on_attach,
  settings = {
    Lua = {
      diagnostics = {
        disable = { "lowercase-global", "redefined-local" },
      },
      runtime = { version = "LuaJIT" },
    },
  },
}) ]]

-- Ignore below

local servers = {
    --[[ lua = {
        install_name = "lua",
        setup_name = "sumneko_lua",
        autoformat_filetypes = {"*.lua"},
        settings = {
            cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
            capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
            settings = {
                Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you"re using (most likely LuaJIT in the case of Neovim)
                        version = "LuaJIT",
                        -- Setup your lua path
                        path = vim.split(package.path, ";")
                    },
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = {"vim"}
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                        },
                        maxPreload = 10000
                    }
                }
            }
        }
    },

    pyright = {
        install_name = "python",
        setup_name = "pyright",
        autoformat_filetypes = {"*.py"},
        settings = {
            capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
            cmd = {vim.fn.stdpath("data") .. "/lspinstall/python/node_modules/.bin/pyright-langserver", "--stdio"},
            handlers = {
                ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
                    virtual_text = true,
                    signs = true,
                    underline = true,
                    update_in_insert = true
                })
            },
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "off",
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true
                    }
                }
            }
        }
    } ]]
}
