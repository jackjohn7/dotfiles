local M = {}

-- Shared on_attach and capabilities for all servers
M.on_attach = function(client, bufnr)
  -- format on save
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true }),
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format()
      end,
    })
  end
end

M.capabilities = require("cmp_nvim_lsp").default_capabilities()

-- enabled but unconfigured servers (https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md)
-- or `:h lspconfig-all`
M.servers = {
  "ts_ls",
  "cssls",
  "tailwindcss",
  "html",
  "jsonls",
  "eslint",
  "pyright",
  "rust_analyzer",
  "lua-language-server",
  "zls",
  "hls",
  "ocamllsp",
  "nil_ls",
}

function M.setup()
  for _, name in ipairs(M.servers) do
    -- Merge base defaults with any local lua/lsp/<server>.lua
    local ok, custom = pcall(require, "lsp." .. name)
    local opts = vim.tbl_deep_extend("force", {
      on_attach = on_attach,
      capabilities = capabilities,
    }, ok and custom or {})

    vim.lsp.config(name, opts)
    vim.lsp.enable(name) -- tells Neovim “this server is available”
  end
end

return M
