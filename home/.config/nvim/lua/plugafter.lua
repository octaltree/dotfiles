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
        vim.keymap.set('n', 'gc', function()
            vim.diagnostic.setqflist()
            vim.cmd('copen')
        end, { noremap = true, silent = true })
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
                    vim.api.nvim_buf_set_option(bufnr, 'statusline', '%f %h%m%r %= %{v:lua.lsp_status()}')
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

    function _G.lsp_status()
        local msg = vim.lsp.status()
        return (msg and msg ~= '') and msg or ''
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
                vim.api.nvim_buf_set_option(bufnr, 'statusline', '%f %h%m%r %= %{v:lua.lsp_status()}')
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


-- Avante.nvim setup
if pcall(require, 'avante') then
    -- Function to read Claude Code credentials
    local function get_claude_token()
      local home = os.getenv("HOME")
      
      -- Check for macOS first (using uname)
      local handle = io.popen("uname")
      local system = handle:read("*a"):gsub("%s+", "")
      handle:close()
      
      if system == "Darwin" then
        -- macOS: Try to get from Keychain
        local keychain_handle = io.popen('security find-generic-password -s "Claude Code" -w 2>/dev/null')
        if keychain_handle then
          local token = keychain_handle:read("*a"):gsub("%s+", "")
          keychain_handle:close()
          if token and token ~= "" then
            return token
          end
        end
      else
        -- Linux: Read from credentials file
        local credentials_path = home .. "/.claude/.credentials.json"
        local file = io.open(credentials_path, "r")
        if file then
          local content = file:read("*all")
          file:close()
          
          local ok, json = pcall(vim.fn.json_decode, content)
          if ok and json and json.claudeAiOauth and json.claudeAiOauth.accessToken then
            return json.claudeAiOauth.accessToken
          end
        end
      end
      
      return nil
    end

    local claude_token = get_claude_token()

    local avante = require('avante')
    avante.setup({
      provider = "claude",
      auto_suggestions = true,
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-3-5-sonnet-20241022",
          timeout = 30000,
          api_key_name = claude_token and ("cmd:echo " .. claude_token) or "ANTHROPIC_API_KEY",
          extra_request_body = {
            temperature = 0,
            max_tokens = 4096,
          },
        },
      },
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = false,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
      },
      mappings = {
        ask = "<leader>cc",
        edit = "<leader>cf",
        refresh = "<leader>cr",
        diff = {
          ours = "<leader>cd",
          theirs = "ct",
          both = "cb",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      hints = { enabled = true },
      windows = {
        position = "right",
        wrap = true,
        width = 30,
        sidebar_header = {
          align = "center",
          rounded = true,
        },
        ask = {
          floating = false,
          border = { " ", " ", " ", " ", " ", " ", " ", " " },
          start_insert = true,  
        },
      },
      ask = {
        floating = false,
        border = { " ", " ", " ", " ", " ", " ", " ", " " },
        start_insert = true,
        focus_on_apply = "ours",
      },
    })
end

-- Diffview.nvim setup and keymaps
if pcall(require, 'diffview') then
    require('diffview').setup({
        diff_binaries = false,
        enhanced_diff_hl = false,
        git_cmd = { "git" },
        use_icons = true,
        show_help_hints = true,
        watch_index = true,
        icons = {
            folder_closed = "",
            folder_open = "",
        },
        signs = {
            fold_closed = "",
            fold_open = "",
            done = "✓",
        },
        view = {
            default = {
                layout = "diff2_horizontal",
                winbar_info = false,
            },
            merge_tool = {
                layout = "diff3_horizontal",
                disable_diagnostics = true,
                winbar_info = true,
            },
            file_history = {
                layout = "diff2_horizontal",
                winbar_info = false,
            },
        },
        file_panel = {
            listing_style = "tree",
            tree_options = {
                flatten_dirs = true,
                folder_statuses = "only_folded",
            },
            win_config = {
                position = "left",
                width = 35,
                win_opts = {}
            },
        },
        file_history_panel = {
            log_options = {
                git = {
                    single_file = {
                        diff_merges = "combined",
                    },
                    multi_file = {
                        diff_merges = "first-parent",
                    },
                },
            },
            win_config = {
                position = "bottom",
                height = 16,
                win_opts = {}
            },
        },
        commit_log_panel = {
            win_config = {
                win_opts = {},
            }
        },
        default_args = {
            DiffviewOpen = {},
            DiffviewFileHistory = {},
        },
        hooks = {},
        keymaps = {
            disable_defaults = false,
            view = {
                {
                    "n",
                    "<tab>",
                    function()
                        require("diffview.actions").select_next_entry()
                    end,
                    { desc = "Open the diff for the next file" }
                },
                {
                    "n",
                    "<s-tab>",
                    function()
                        require("diffview.actions").select_prev_entry()
                    end,
                    { desc = "Open the diff for the previous file" }
                },
                {
                    "n",
                    "gf",
                    function()
                        require("diffview.actions").goto_file()
                    end,
                    { desc = "Open the file in the previous tabpage" }
                },
                {
                    "n",
                    "<C-w><C-f>",
                    function()
                        require("diffview.actions").goto_file_split()
                    end,
                    { desc = "Open the file in a new split" }
                },
                {
                    "n",
                    "<C-w>gf",
                    function()
                        require("diffview.actions").goto_file_tab()
                    end,
                    { desc = "Open the file in a new tabpage" }
                },
                {
                    "n",
                    "<space>e",
                    function()
                        require("diffview.actions").toggle_files()
                    end,
                    { desc = "Toggle the file panel." }
                },
                {
                    "n",
                    "<space>b",
                    function()
                        require("diffview.actions").toggle_files()
                    end,
                    { desc = "Toggle the file panel" }
                },
                {
                    "n",
                    "g<C-x>",
                    function()
                        require("diffview.actions").cycle_layout()
                    end,
                    { desc = "Cycle through available layouts." }
                },
                {
                    "n",
                    "[x",
                    function()
                        require("diffview.actions").prev_conflict()
                    end,
                    { desc = "In the merge-tool: jump to the previous conflict" }
                },
                {
                    "n",
                    "]x",
                    function()
                        require("diffview.actions").next_conflict()
                    end,
                    { desc = "In the merge-tool: jump to the next conflict" }
                },
                {
                    "n",
                    "<space>co",
                    function()
                        require("diffview.actions").conflict_choose("ours")
                    end,
                    { desc = "Choose the OURS version of a conflict" }
                },
                {
                    "n",
                    "<space>ct",
                    function()
                        require("diffview.actions").conflict_choose("theirs")
                    end,
                    { desc = "Choose the THEIRS version of a conflict" }
                },
                {
                    "n",
                    "<space>cb",
                    function()
                        require("diffview.actions").conflict_choose("both")
                    end,
                    { desc = "Choose the BOTH versions of a conflict" }
                },
                {
                    "n",
                    "<space>c0",
                    function()
                        require("diffview.actions").conflict_choose("none")
                    end,
                    { desc = "Delete the conflict region" }
                },
                {
                    "n",
                    "dq",
                    "<Cmd>DiffviewClose<CR>",
                    { desc = "Close diffview" }
                },
            },
            diff1 = {
                {
                    "n",
                    "g?",
                    function()
                        require("diffview.actions").help("view")
                    end,
                    { desc = "Open the help panel" }
                },
            },
            diff2 = {
                {
                    "n",
                    "g?",
                    function()
                        require("diffview.actions").help("view")
                    end,
                    { desc = "Open the help panel" }
                },
            },
            diff3 = {
                {
                    "n",
                    "g?",
                    function()
                        require("diffview.actions").help("view")
                    end,
                    { desc = "Open the help panel" }
                },
            },
            diff4 = {
                {
                    "n",
                    "g?",
                    function()
                        require("diffview.actions").help("view")
                    end,
                    { desc = "Open the help panel" }
                },
            },
            file_panel = {
                {
                    "n",
                    "j",
                    function()
                        require("diffview.actions").next_entry()
                    end,
                    { desc = "Bring the cursor to the next file entry" }
                },
                {
                    "n",
                    "<down>",
                    function()
                        require("diffview.actions").next_entry()
                    end,
                    { desc = "Bring the cursor to the next file entry" }
                },
                {
                    "n",
                    "k",
                    function()
                        require("diffview.actions").prev_entry()
                    end,
                    { desc = "Bring the cursor to the previous file entry." }
                },
                {
                    "n",
                    "<up>",
                    function()
                        require("diffview.actions").prev_entry()
                    end,
                    { desc = "Bring the cursor to the previous file entry." }
                },
                {
                    "n",
                    "<cr>",
                    function()
                        require("diffview.actions").select_entry()
                    end,
                    { desc = "Open the diff for the selected entry." }
                },
                {
                    "n",
                    "o",
                    function()
                        require("diffview.actions").select_entry()
                    end,
                    { desc = "Open the diff for the selected entry." }
                },
                {
                    "n",
                    "l",
                    function()
                        require("diffview.actions").select_entry()
                    end,
                    { desc = "Open the diff for the selected entry." }
                },
                {
                    "n",
                    "<2-LeftMouse>",
                    function()
                        require("diffview.actions").select_entry()
                    end,
                    { desc = "Open the diff for the selected entry." }
                },
                {
                    "n",
                    "-",
                    function()
                        require("diffview.actions").toggle_stage_entry()
                    end,
                    { desc = "Stage / unstage the selected entry." }
                },
                {
                    "n",
                    "s",
                    function()
                        require("diffview.actions").toggle_stage_entry()
                    end,
                    { desc = "Stage / unstage the selected entry." }
                },
                {
                    "n",
                    "S",
                    function()
                        require("diffview.actions").stage_all()
                    end,
                    { desc = "Stage all entries." }
                },
                {
                    "n",
                    "U",
                    function()
                        require("diffview.actions").unstage_all()
                    end,
                    { desc = "Unstage all entries." }
                },
                {
                    "n",
                    "X",
                    function()
                        require("diffview.actions").restore_entry()
                    end,
                    { desc = "Restore entry to the state on the left side." }
                },
                {
                    "n",
                    "L",
                    function()
                        require("diffview.actions").open_commit_log()
                    end,
                    { desc = "Open the commit log panel." }
                },
                {
                    "n",
                    "zo",
                    function()
                        require("diffview.actions").open_fold()
                    end,
                    { desc = "Expand fold" }
                },
                {
                    "n",
                    "h",
                    function()
                        require("diffview.actions").close_fold()
                    end,
                    { desc = "Collapse fold" }
                },
                {
                    "n",
                    "zc",
                    function()
                        require("diffview.actions").close_fold()
                    end,
                    { desc = "Collapse fold" }
                },
                {
                    "n",
                    "za",
                    function()
                        require("diffview.actions").toggle_fold()
                    end,
                    { desc = "Toggle fold" }
                },
                {
                    "n",
                    "zR",
                    function()
                        require("diffview.actions").open_all_folds()
                    end,
                    { desc = "Expand all folds" }
                },
                {
                    "n",
                    "zM",
                    function()
                        require("diffview.actions").close_all_folds()
                    end,
                    { desc = "Collapse all folds" }
                },
                {
                    "n",
                    "<c-b>",
                    function()
                        require("diffview.actions").scroll_view(-0.25)
                    end,
                    { desc = "Scroll the view up" }
                },
                {
                    "n",
                    "<c-f>",
                    function()
                        require("diffview.actions").scroll_view(0.25)
                    end,
                    { desc = "Scroll the view down" }
                },
                {
                    "n",
                    "<tab>",
                    function()
                        require("diffview.actions").select_next_entry()
                    end,
                    { desc = "Open the diff for the next file" }
                },
                {
                    "n",
                    "<s-tab>",
                    function()
                        require("diffview.actions").select_prev_entry()
                    end,
                    { desc = "Open the diff for the previous file" }
                },
                {
                    "n",
                    "gf",
                    function()
                        require("diffview.actions").goto_file()
                    end,
                    { desc = "Open the file in the previous tabpage" }
                },
                {
                    "n",
                    "<C-w><C-f>",
                    function()
                        require("diffview.actions").goto_file_split()
                    end,
                    { desc = "Open the file in a new split" }
                },
                {
                    "n",
                    "<C-w>gf",
                    function()
                        require("diffview.actions").goto_file_tab()
                    end,
                    { desc = "Open the file in a new tabpage" }
                },
                {
                    "n",
                    "i",
                    function()
                        require("diffview.actions").listing_style()
                    end,
                    { desc = "Toggle between 'list' and 'tree' views" }
                },
                {
                    "n",
                    "f",
                    function()
                        require("diffview.actions").toggle_flatten_dirs()
                    end,
                    { desc = "Flatten empty subdirectories in tree listing style." }
                },
                {
                    "n",
                    "R",
                    function()
                        require("diffview.actions").refresh_files()
                    end,
                    { desc = "Update stats and entries in the file list." }
                },
                {
                    "n",
                    "<space>e",
                    function()
                        require("diffview.actions").toggle_files()
                    end,
                    { desc = "Toggle the file panel" }
                },
                {
                    "n",
                    "<space>b",
                    function()
                        require("diffview.actions").toggle_files()
                    end,
                    { desc = "Toggle the file panel" }
                },
                {
                    "n",
                    "g<C-x>",
                    function()
                        require("diffview.actions").cycle_layout()
                    end,
                    { desc = "Cycle through available layouts." }
                },
                {
                    "n",
                    "[x",
                    function()
                        require("diffview.actions").prev_conflict()
                    end,
                    { desc = "In the merge-tool: jump to the previous conflict" }
                },
                {
                    "n",
                    "]x",
                    function()
                        require("diffview.actions").next_conflict()
                    end,
                    { desc = "In the merge-tool: jump to the next conflict" }
                },
                {
                    "n",
                    "g?",
                    function()
                        require("diffview.actions").help("file_panel")
                    end,
                    { desc = "Open the help panel" }
                },
                {
                    "n",
                    "dq",
                    "<Cmd>DiffviewClose<CR>",
                    { desc = "Close diffview" }
                },
            },
            file_history_panel = {
                {
                    "n",
                    "g!",
                    function()
                        require("diffview.actions").options()
                    end,
                    { desc = "Open the option panel" }
                },
                {
                    "n",
                    "<C-A-d>",
                    function()
                        require("diffview.actions").open_in_diffview()
                    end,
                    { desc = "Open the entry under the cursor in a diffview" }
                },
                {
                    "n",
                    "y",
                    function()
                        require("diffview.actions").copy_hash()
                    end,
                    { desc = "Copy the commit hash of the entry under the cursor" }
                },
                {
                    "n",
                    "L",
                    function()
                        require("diffview.actions").open_commit_log()
                    end,
                    { desc = "Show commit details" }
                },
                {
                    "n",
                    "zR",
                    function()
                        require("diffview.actions").open_all_folds()
                    end,
                    { desc = "Expand all folds" }
                },
                {
                    "n",
                    "zM",
                    function()
                        require("diffview.actions").close_all_folds()
                    end,
                    { desc = "Collapse all folds" }
                },
                {
                    "n",
                    "j",
                    function()
                        require("diffview.actions").next_entry()
                    end,
                    { desc = "Bring the cursor to the next file entry" }
                },
                {
                    "n",
                    "<down>",
                    function()
                        require("diffview.actions").next_entry()
                    end,
                    { desc = "Bring the cursor to the next file entry" }
                },
                {
                    "n",
                    "k",
                    function()
                        require("diffview.actions").prev_entry()
                    end,
                    { desc = "Bring the cursor to the previous file entry." }
                },
                {
                    "n",
                    "<up>",
                    function()
                        require("diffview.actions").prev_entry()
                    end,
                    { desc = "Bring the cursor to the previous file entry." }
                },
                {
                    "n",
                    "<cr>",
                    function()
                        require("diffview.actions").select_entry()
                    end,
                    { desc = "Open the diff for the selected entry." }
                },
                {
                    "n",
                    "o",
                    function()
                        require("diffview.actions").select_entry()
                    end,
                    { desc = "Open the diff for the selected entry." }
                },
                {
                    "n",
                    "<2-LeftMouse>",
                    function()
                        require("diffview.actions").select_entry()
                    end,
                    { desc = "Open the diff for the selected entry." }
                },
                {
                    "n",
                    "<c-b>",
                    function()
                        require("diffview.actions").scroll_view(-0.25)
                    end,
                    { desc = "Scroll the view up" }
                },
                {
                    "n",
                    "<c-f>",
                    function()
                        require("diffview.actions").scroll_view(0.25)
                    end,
                    { desc = "Scroll the view down" }
                },
                {
                    "n",
                    "<tab>",
                    function()
                        require("diffview.actions").select_next_entry()
                    end,
                    { desc = "Open the diff for the next file" }
                },
                {
                    "n",
                    "<s-tab>",
                    function()
                        require("diffview.actions").select_prev_entry()
                    end,
                    { desc = "Open the diff for the previous file" }
                },
                {
                    "n",
                    "gf",
                    function()
                        require("diffview.actions").goto_file()
                    end,
                    { desc = "Open the file in the previous tabpage" }
                },
                {
                    "n",
                    "<C-w><C-f>",
                    function()
                        require("diffview.actions").goto_file_split()
                    end,
                    { desc = "Open the file in a new split" }
                },
                {
                    "n",
                    "<C-w>gf",
                    function()
                        require("diffview.actions").goto_file_tab()
                    end,
                    { desc = "Open the file in a new tabpage" }
                },
                {
                    "n",
                    "<space>e",
                    function()
                        require("diffview.actions").toggle_files()
                    end,
                    { desc = "Toggle the file panel" }
                },
                {
                    "n",
                    "<space>b",
                    function()
                        require("diffview.actions").toggle_files()
                    end,
                    { desc = "Toggle the file panel" }
                },
                {
                    "n",
                    "g<C-x>",
                    function()
                        require("diffview.actions").cycle_layout()
                    end,
                    { desc = "Cycle through available layouts." }
                },
                {
                    "n",
                    "g?",
                    function()
                        require("diffview.actions").help("file_history_panel")
                    end,
                    { desc = "Open the help panel" }
                },
                {
                    "n",
                    "dq",
                    "<Cmd>DiffviewClose<CR>",
                    { desc = "Close diffview" }
                },
            },
            option_panel = {
                {
                    "n",
                    "<tab>",
                    function()
                        require("diffview.actions").select_entry()
                    end,
                    { desc = "Change the current option" }
                },
                {
                    "n",
                    "q",
                    function()
                        require("diffview.actions").close()
                    end,
                    { desc = "Close the option panel" }
                },
                {
                    "n",
                    "<esc>",
                    function()
                        require("diffview.actions").close()
                    end,
                    { desc = "Close the option panel" }
                },
            },
            help_panel = {
                {
                    "n",
                    "q",
                    function()
                        require("diffview.actions").close()
                    end,
                    { desc = "Close help menu" }
                },
                {
                    "n",
                    "<esc>",
                    function()
                        require("diffview.actions").close()
                    end,
                    { desc = "Close help menu" }
                },
            },
        },
    })

    -- Global keymaps
    vim.keymap.set('n', '<space>hd', ':DiffviewOpen HEAD~1<CR>', { noremap = true, silent = true, desc = 'Show diff between HEAD and HEAD~1' })
    vim.keymap.set('n', '<space>hf', ':DiffviewFileHistory %<CR>', { noremap = true, silent = true, desc = 'Show file history for current file' })
    vim.keymap.set('n', '<space>hh', ':DiffviewFileHistory<CR>', { noremap = true, silent = true, desc = 'Show file history for all files' })
    vim.keymap.set('n', '<space>ho', ':DiffviewOpen<CR>', { noremap = true, silent = true, desc = 'Open diffview' })
    vim.keymap.set('n', '<space>hc', ':DiffviewClose<CR>', { noremap = true, silent = true, desc = 'Close diffview' })
    
    -- Neogitのログビューでdiffviewを開くキーマップを追加
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "NeogitLogView",
        callback = function()
            vim.keymap.set('n', 'D', function()
                local line = vim.fn.getline('.')
                local commit = line:match('^(%x+)')
                if commit then
                    vim.cmd('DiffviewOpen ' .. commit .. '~1..' .. commit)
                end
            end, { buffer = true, desc = 'Open diffview for this commit' })
        end
    })
end

-- %! lua-format --no-keep-simple-function-one-line --chop-down-table
-- vim: ts=4 sw=4
