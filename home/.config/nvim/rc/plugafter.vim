lua <<EOF
local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local lsp = vim.lsp

local capabilities = vim.lsp.protocol.make_client_capabilities()

configs.web_browser_lsp = {
  default_config = {
    cmd = {"web-browser-lsp"},
    filetypes = {"textbrowser"},
    settings = {
      ['web-browser-lsp'] = {
      }
    }
  },
  commands = {},
  docs = {},
}
EOF

autocmd FileType textbrowser call LC_maps()
