lua <<EOF
local success, ts_config = pcall(require, 'nvim-treesitter.configs')
if success then
  ts_config.setup {
    highlight = {
      enable = true,
      disable = {'json', 'csv'}
    }
  }
end
EOF

augroup cmdwin_highlight
  au!
  au CmdwinEnter * syntax on
augroup END
