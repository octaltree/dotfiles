if pcall(require, 'linearf') and pcall(require, 'linearf-my-flavors') then
    local linearf = require('linearf')
    local flavors = require('linearf-my-flavors')
    -- linearf._debug = true
    local vanilla = require('linearf-vanilla')
    linearf.init(require('linearf-vanilla').new())
    linearf.recipe.sources = {
        {name = "identity", path = "flavors_plain::Identity"},
        {name = "command", path = "flavors_tokio::Command"},
        {name = "rustdoc", path = "flavors_rustdoc::Rustdoc"}
    }
    linearf.recipe.converters = {
        {name = "format_line", path = "flavors_plain::FormatLine"}
    }
    linearf.recipe.matchers = {
        {name = "identity", path = "flavors_plain::Identity"},
        {name = "substring", path = "flavors_plain::Substring"},
        {name = "clap", path = "flavors_clap::Clap"}
    }
    linearf.recipe.actions = {
        {name = "rustdoc_item", path = "flavors_rustdoc::RustdocItem"}
    }
    local alias_escape_querier = {
        linearf = {
            list_nnoremap = {},
            querier_inoremap = {
                ["<A-space>"] = flavors.normal_and(
                    flavors.actions.view.goto_list)
            },
            querier_nnoremap = {["<A-space>"] = flavors.actions.view.goto_list}
        }
    }
    local function set(target, context_manager, scenario)
        linearf.context_managers[target] = context_manager
        linearf.scenarios[target] = scenario
    end
    set('line', flavors.context_managers['line'], flavors.merge {
        flavors.scenarios['line'],
        flavors.scenarios.quit,
        flavors.scenarios.no_list_insert,
        flavors.scenarios.no_querier_normal,
        alias_escape_querier,
        {
            linearf = {
                list_nnoremap = {
                    ["<CR>"] = flavors.hide_and(flavors.actions.line.jump)
                },
                querier_inoremap = {
                    ["<CR>"] = flavors.normal_and(flavors.hide_and(
                                                      flavors.actions.line.jump))
                }
            },
            view = {querier_on_start = 'insert'}
        }
    })
    set('file', flavors.context_managers['file_rg'], flavors.merge {
        flavors.scenarios['file_rg'],
        flavors.scenarios.quit,
        flavors.scenarios.no_list_insert,
        flavors.scenarios.no_querier_normal,
        alias_escape_querier,
        {
            linearf = {
                list_nnoremap = {
                    ["<CR>"] = flavors.hide_and(flavors.actions.file.open),
                    ["<nowait>s"] = flavors.hide_and(flavors.actions.file.split),
                    ["t"] = flavors.hide_and(flavors.actions.file.tabopen),
                    ["v"] = flavors.hide_and(flavors.actions.file.vsplit)
                },
                querier_inoremap = {
                    ["<CR>"] = flavors.normal_and(flavors.hide_and(
                                                      flavors.actions.file.open))
                }
            }
        }
    })
    set('grep', flavors.context_managers['grep_rg'], flavors.merge {
        flavors.scenarios['grep_rg'],
        flavors.scenarios.quit,
        flavors.scenarios.no_list_insert,
        flavors.scenarios.enter_list,
        {
            linearf = {
                list_nnoremap = {
                    ["<CR>"] = flavors.hide_and(flavors.actions.grep.open),
                    ["<nowait>s"] = flavors.hide_and(flavors.actions.grep.split),
                    ["t"] = flavors.hide_and(flavors.actions.grep.tabopen),
                    ["v"] = flavors.hide_and(flavors.actions.grep.vsplit)
                },
                querier_inoremap = {},
                querier_nnoremap = {
                    ["<nowait><ESC>"] = flavors.actions.view.goto_list,
                    ["<A-space>"] = flavors.actions.view.goto_list
                }
            }
        }
    })
    set('dir_line', flavors.context_managers['grep_rg'], flavors.merge {
        flavors.scenarios['dir_line_rg'],
        flavors.scenarios.quit,
        flavors.scenarios.no_list_insert,
        flavors.scenarios.enter_list,
        {
            linearf = {
                list_nnoremap = {
                    ["<CR>"] = flavors.hide_and(flavors.actions.dir_line.open),
                    ["<nowait>s"] = flavors.hide_and(
                        flavors.actions.dir_line.split),
                    ["t"] = flavors.hide_and(flavors.actions.dir_line.tabopen),
                    ["v"] = flavors.hide_and(flavors.actions.dir_line.vsplit)
                },
                querier_inoremap = {},
                querier_nnoremap = {
                    ["<nowait><ESC>"] = flavors.actions.view.goto_list,
                    ["<A-space>"] = flavors.actions.view.goto_list
                }
            }
        }
    })
    set('rustdoc', flavors.context_managers['rustdoc'], flavors.merge {
        flavors.scenarios['rustdoc'],
        flavors.scenarios.quit,
        flavors.scenarios.no_list_insert,
        flavors.scenarios.no_querier_normal,
        alias_escape_querier,
        {
            linearf = {
                list_nnoremap = {
                    ["<CR>"] = flavors.hide_and(
                        flavors.actions.rustdoc.open_firefox)
                }
            }
        }
    })

    linearf.bridge.try_build_if_not_exist = true
    linearf.bridge.try_build_on_error = false

    linearf.utils.command("nnoremap <silent><space>/ :<c-u>lua lnf('line')<CR>")
    linearf.utils.command("nnoremap <silent><space>f :<c-u>lua lnf('file')<CR>")
    linearf.utils.command("nnoremap <silent><space>g :<c-u>lua lnf('grep')<CR>")
    linearf.utils.command("nnoremap <silent><space>s :<c-u>lua lnf('rustdoc')<CR>")
    linearf.utils.command(
        "nnoremap <silent><space>l :<c-u>lua lnf.resume_last()<CR>")
end

if pcall(require, 'nvim-treesitter') then
    local ts_config = require('nvim-treesitter.configs')
    ts_config.setup {highlight = {enable = true, disable = {'json', 'csv'}}}
end

do
    local M = {servers = {}, cache = {executable = {}}}
    _G['_my_lsp'] = M

    local function executable(bin)
        local cache = M.cache
        if type(cache.executable[bin]) == 'boolean' then
            return cache.executable[bin]
        end
        cache.executable[bin] = vim.fn.executable(bin) == 1
        return cache.executable[bin]
    end

    local function default_keybind(bufnr)
        local function nnor(l, r)
            local opts = {noremap = true, silent = true}
            vim.api.nvim_buf_set_keymap(bufnr, 'n', l, r, opts)
        end
        nnor('<c-]', '<cmd>lua vim.lsp.buf.declaration()<CR>')
        nnor('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
        nnor('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
        nnor('gD', '<cmd>lua vim.lsp.buf.implementation()<CR>')
        nnor('<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
        nnor('1gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
        nnor('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
        nnor('g0', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
        nnor('gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
        nnor('ss', '<cmd>lua vim.lsp.buf.formatting()<CR>')
        nnor('ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
        nnor('gc', '<cmd>lua vim.diagnostic.setloclist()<CR>')
        -- 必ずしもカレントバッファとは限らないが
        vim.api.nvim_command('setlocal signcolumn=yes')
    end

    local function cmp(cap)
        local ok, mod = pcall(require, 'cmp_nvim_lsp')
        if not ok then return cap end
        return mod.default_capabilities(cap, {
            snippetSupport = false
        })
    end

    local function default(server)
        return function()
            local config = require('lspconfig')[server]
            local cmd = config.document_config.default_config.cmd[1]
            if not executable(cmd) then return end
            local cap = cmp(vim.lsp.protocol.make_client_capabilities())
            config.setup({
                capabilities = cap,
                on_attach = function(_client, bufnr)
                    default_keybind(bufnr)
                end
            })
        end
    end

    local function use_default(fts, server)
        for _, ft in ipairs(fts) do M.servers[ft] = default(server) end
    end

    local function au(evt, target, cmd)
        vim.api.nvim_command(string.format('au %s %s %s', evt, target, cmd))
    end

    function M.servers.rust()
        local config = require('lspconfig')['rust_analyzer']
        local cmd = config.document_config.default_config.cmd[1]
        if not executable(cmd) then return end
        local cap
        do
            cap = vim.lsp.protocol.make_client_capabilities()
            cap.textDocument.completion.completionItem.snippetSupport = true;
            cap.textDocument.completion.completionItem.resolveSupport = {
                properties = {'documentation', 'detail', 'additionalTextEdits'}
            }
            cap = cmp(cap)
        end
        config.setup {
            capabilities = cap,
            settings = {
                ["rust-analyzer"] = {
                    check = {command = "clippy"},
                    diagnostics = {
                        enable = true,
                        experimental = {enable = true}
                    },
                    cargo = {
                        buildScripts = {
                            enable = true,
                        },
                    },
                    procMacro = {enable = true},
                    lruCapacity = 512
                }
            },
            on_attach = function(_client, bufnr)
                default_keybind(bufnr)
                M._rust = function()
                    require('lsp_extensions').inlay_hints {
                        prefix = " » ",
                        highlight = "Comment",
                        only_current_line = false,
                        enabled = {"TypeHint", "ChainingHint", "ParameterHint"}
                    }
                end
                local evt = table.concat({
                    'CursorMoved',
                    'InsertLeave',
                    'BufEnter',
                    'BufWinEnter',
                    'TabEnter',
                    'BufWritePost'
                }, ',')
                au(evt, '*', "lua _G['_my_lsp']._rust()")
            end
        }
    end

    function M.ready()
        for _, f in pairs(M.servers) do f() end
    end

    use_default({'c', 'cpp'}, 'clangd')
    use_default({'sh'}, 'bashls')
    use_default({'python'}, 'pylsp')
    use_default({'javascript', 'typescript'}, 'denols')
    -- use_default({'javascript', 'typescript'}, 'tsserver')
    use_default({'tex'}, 'texlab')
    use_default({'graphql'}, 'graphql')
    -- ansiblels.lua
    -- cmake.lua
    -- dockerls.lua
    -- dotls.lua
    -- graphql.lua
    -- cssls.lua
    -- html.lua
    -- stylelint_lsp.lua
    -- sqlls.lua
    -- sqls.lua
    -- sumneko_lua.lua
    -- vimls.lua

    -- clojure_lsp.lua
    -- csharp_ls.lua
    -- dartls.lua
    -- erlangls.lua
    -- flow.lua
    -- hls.lua
    -- java_language_server.lua
    -- jdtls.lua
    -- kotlin_language_server.lua
    -- metals.lua
    -- purescriptls.lua

    au('User', 'LspconfigSource', "lua _G['_my_lsp'].ready()")
end

if vim.g.completion == 'cmp' and pcall(require, 'cmp') then
    local M = {}
    _G['_my_cmp'] = M
    local cmp = require('cmp')
    local sources = {
        {name = 'path'},
        {name = 'nvim_lsp'},
        {name = 'nvim_lsp_signature_help'},
        {name = 'nvim_lua'},
        {name = 'vsnip'},
        {name = 'buffer'},
        {name = 'treesitter'},
        {name = 'tmux'},
        {
            name = 'look',
            keyword_length = 5,
            option = {convert_case = true, loud = true}
        }
    }
    cmp.setup({
        sources = sources,
        preselect = false,
        completion = {
            autocomplete = {
                require('cmp.types').cmp.TriggerEvent.InsertEnter,
                require('cmp.types').cmp.TriggerEvent.TextChanged
            }
        },
        snippet = {
            expand = function(args)
                -- print(vim.inspect(args))
                vim.fn["vsnip#anonymous"](args.body)
            end
        },
        mapping = {
            ['<c-n>'] = cmp.mapping.select_next_item(),
            ['<c-p>'] = cmp.mapping.select_prev_item(),
            ['<c-e>'] = cmp.mapping.confirm({select = false})
        }
    })

    function M.vim()
        local ss = {}
        table.insert(ss, {name = 'cmdline'})
        for _, x in ipairs(sources) do table.insert(ss, x) end
        cmp.setup.buffer({sources = ss})
    end
    vim.cmd('au Filetype vim lua _G["_my_cmp"].vim()')

    do
        local cmdline = require('cmp_cmdline').new()
        cmdline.is_available = function() return true end
        cmp.register_source('cmdline', cmdline)
    end

    cmp.setup.cmdline(':', {sources = {{name = 'cmdline'}}})
    vim.cmd('set completeopt+=menuone,noselect')
end

-- claudecode.nvim setup
if pcall(require, 'claudecode') then
    require('claudecode').setup({
        -- Server Configuration
        port_range = { min = 10000, max = 65535 },
        auto_start = true,
        log_level = "info",

        -- Terminal Configuration
        terminal = {
            split_side = "right",
            split_width_percentage = 0.30,
            provider = "native",
            auto_close = true
        },

        -- Diff Integration
        diff_opts = {
            auto_close_on_accept = true,
            vertical_split = true,
            open_in_current_tab = true
        }
    })

    -- Key mappings
    vim.keymap.set('n', '<space>cc', '<cmd>ClaudeCode<cr>', { desc = 'Toggle Claude' })
    vim.keymap.set('n', '<space>cf', '<cmd>ClaudeCodeFocus<cr>', { desc = 'Focus Claude' })
    vim.keymap.set('v', '<space>cs', '<cmd>ClaudeCodeSend<cr>', { desc = 'Send to Claude' })
    vim.keymap.set('n', '<space>cd', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'Accept Claude diff' })
    vim.keymap.set('n', '<space>cr', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = 'Reject Claude diff' })
end

-- %! lua-format --no-keep-simple-function-one-line --chop-down-table
-- vim: ts=4 sw=4
