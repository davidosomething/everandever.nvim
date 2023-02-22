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
  return vim.tbl_deep_extend("force", {
    condition = require("heirline.conditions").lsp_attached,
    update = {
      "LspAttach",
      "LspDetach",
      "User LspProgressUpdate",
      "User LspRequest",
    },
    provider = function()
      local data = require("everandever.lsp").status_progress({ bufnr = 0 })
      if data then
        return " " .. data.bar .. " " .. data.lowest.name .. " "
      end
      return ""
    end,
  }, opts)
end
