local M = {}

M.VERTICAL = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
M.HORIZONTAL = { "▏", "▎", "▍", "▌", "▋", "▊", "▉" }

---@param frames table
---@param percent number
---@return string
M.character = function(frames, percent)
  -- 17 for VERTICAL
  local frame_interval = math.ceil(100 / #frames)
  -- 0%, 0/17 = 0 -> max 1
  -- 1%, 1/17 = 0.05 -> ceil 1
  -- 30%, 30/17 = 1.76 -> 2
  -- 100%, 30/17 = 5.88 -> 6
  local frame_index = math.max(1, math.ceil((percent or 0) / frame_interval))
  return frames[frame_index]
end

return M
