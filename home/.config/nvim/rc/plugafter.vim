lua <<EOF
local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local lsp = vim.lsp

configs.web_browser_lsp = {
  default_config = {
    cmd = {"/home/octaltree/workspace/web-browser-lsp/target/debug/web-browser-lsp"},
    filetypes = {"textbrowser"},
    root_dir = function(fname)
      return vim.fn.getcwd()
    end,
    settings = {
      ["web-browser-lsp"] = {}
    }
  },
  commands = {},
  docs = {
    package_json = "",
    description = "",
    default_config = {}
  }
};

local capabilities = lsp.protocol.make_client_capabilities()

require'lspconfig'.web_browser_lsp.setup{
  capabilities = capabilities,
  settings = {
    ["web-browser-lsp"] = {
    }
  }
}
EOF

autocmd BufNewFile,BufRead *.textbrowser setlocal filetype=textbrowser
autocmd FileType textbrowser call LC_maps()
