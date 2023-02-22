# everandever.nvim

Lua utilities for composing an LSP progress indicator.

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

### heirline example

Can be found [here](./lua/everandever/heirline.lua)

## License

MIT