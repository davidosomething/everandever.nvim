# everandever.nvim

Lua utilities for composing an LSP progress indicator.
See a [demo video](https://user-images.githubusercontent.com/609213/220507323-635ef4c1-1089-432e-96e8-73b4493051f9.mp4)

## Installation

These are strictly lua modules, they do nothing unless specifically required
by your own config. Install by adding to your plugin manager, no lazy loading
required.

- lazy.nvim

    ```lua
    { "davidosomething/everandever.nvim" }
    ```

## Usage

### Get progress messages for given buffer

```lua
local opts = { bufnr = 0 }
vim.pretty_print(
  require('everandever.lsp').get_progress_messages(opts)
)
```

`opts` is passed directly to `vim.lsp.get_active_clients(opts)`

### Get messages, lowest % of the messages, and a bar character like `▄`

```lua
vim.pretty_print(
  require('everandever.progress').status_progress({ bufnr = 0 })
)
```

### Convert a number percentage to a status bar character

```lua
local progress = require('everandever.progress')

vim.pretty_print(
  progress.character(progress.VERTICAL, 75)
)

vim.pretty_print(
  progress.character(progress.HORIZONTAL, 75)
)
```

### lualine example

```lua
local function lspprogress()
  local data = require('everandever.progress').status_progress({ bufnr = 0 })
  return " " .. data.bar .. " " .. data.lowest.name .. " "
end

...

sections = { lualine_c = { lspprogress } }
```

### heirline.nvim example

Can be found [here](./lua/everandever/heirline.lua) (very similar to lualine)

## License

MIT
