-- Usage
--
--  require('heirline').setup({
--    statusline = {
--      -- ...
--      require('everandever.heirline')({ hl = 'StatusLine' }),
--      -- ...
--    }
--  }
--
---@param opts table
---@return table heirline component
return function(opts)
  opts = opts or {}

  -- as of https://github.com/neovim/neovim/pull/23958/files
  local lsp_progress_event = vim.fn.exists("##LspProgress") == 1
      and "LspProgress"
    or "User LspProgressUpdate"

  return vim.tbl_deep_extend("force", {
    condition = require("heirline.conditions").lsp_attached,
    update = {
      "LspAttach",
      "LspDetach",
      lsp_progress_event,
      "User LspRequest",
    },
    provider = function()
      local data = require("everandever.lsp").status_progress({ bufnr = 0 })
      if data then
        return (" %s $s "):format(data.bar, data.lowest.name)
      end
      return ""
    end,
  }, opts)
end
