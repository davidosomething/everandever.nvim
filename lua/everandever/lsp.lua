local M = {}

---@class ProgressMessage
---@field name string client name e.g. lua_ls or null-ls
---@field title string usually what the client is doing
---@field message string sometimes filename, for null-ls it is the source name
---@field percentage number
---@field done boolean
---@field progress boolean

-- ripped directly from $VIMRUNTIME/lua/vim/lsp/util.lua and added filter
-- param
--- Process and return progress reports from lsp server
---@param filter (table|nil) A table with key-value pairs used to filter the
---              returned clients. The available keys are:
---               - id (number): Only return clients with the given id
---               - bufnr (number): Only return clients attached to this buffer
---               - name (string): Only return clients with the given name
function M.get_progress_messages(filter)
  local new_messages = {}
  local progress_remove = {}

  for _, client in ipairs(vim.lsp.get_active_clients(filter)) do

    -- @TODO switch to client.progress only
    -- https://github.com/neovim/neovim/pull/23958/files#diff-de132e20a0c678f2ff3234a05d868b0d118561cb72317910e7f28839640ed2e3R363-R388
    if vim.lsp.status then
      local groups = {}
      for progress in client.progress do
        local value = progress.value
        if type(value) == 'table' and value.kind then
          local group = groups[progress.token]
          if not group then
            group = {
              done = false,
              progress = true,
              title = 'empty title',
            }
            groups[progress.token] = group
          end
          group.title = value.title or group.title
          group.cancellable = value.cancellable or group.cancellable
          if value.kind == 'end' then
            group.done = true
          end
          group.message = value.message or group.message
          group.percentage = value.percentage or group.percentage
        end
      end

      for _, group in pairs(groups) do
        table.insert(new_messages, group)
      end
    end
    -- @TODO end


    local messages = client.messages
    local data = messages
    for token, ctx in pairs(data.progress) do
      local new_report = {
        name = data.name,
        title = ctx.title or "empty title",
        message = ctx.message,
        percentage = ctx.percentage,
        done = ctx.done,
        progress = true,
      }
      table.insert(new_messages, new_report)

      if ctx.done then
        table.insert(progress_remove, { client = client, token = token })
      end
    end
  end

  for _, item in ipairs(progress_remove) do
    item.client.messages.progress[item.token] = nil
  end

  return new_messages
end

--- Hook this into
--- LspAttach, LspDetach, User LspProgressUpdate, and User LspRequest
---@param filter (table|nil) A table with key-value pairs used to filter the
---              returned clients. The available keys are:
---               - id (number): Only return clients with the given id
---               - bufnr (number): Only return clients attached to this buffer
---               - name (string): Only return clients with the given name
---@param charset? string
---| `VERTICAL`   # vertical progress bar
---| `HORIZONTAL` # horizontal progress bar
M.status_progress = function(filter, charset)
  charset = charset or "VERTICAL"

  local messages
  if vim.lsp.status then
    local message = vim.lsp.status()
    messages = message == '' and {} or { message }
  else
    ---@type ProgressMessage[]
    messages = M.get_progress_messages(filter)
  end

  if #messages == 0 then
    return nil
  end

  local lowest = { percentage = 100 }
  for _, data in pairs(messages) do
    (function()
      if
        data.done
        or not data.progress
        or not data.percentage
        or data.percentage == 100
      then
        return
      end
      if data.percentage < lowest.percentage then
        lowest = data
      end
    end)()
  end
  if lowest.percentage == 100 then
    return nil
  end

  if lowest.name == "null-ls" and lowest.message then
    lowest.name = ("null-ls[%s]"):format(lowest.message)
  end
  local progress = require("everandever.progress")
  local bar = progress.character(progress[charset], lowest.percentage)
  return { messages = messages, lowest = lowest, bar = bar }
end

return M
